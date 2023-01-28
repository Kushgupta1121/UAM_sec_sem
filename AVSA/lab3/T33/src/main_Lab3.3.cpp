/*
 * main_Lab3.3.cpp
 *
 *  Created on: Apr 27, 2022
 *      Author: avsa
 */


//includes
#include <opencv2/opencv.hpp> 	//opencv libraries
#include <opencv2/bgsegm.hpp>
#include "ShowManyImages.hpp"
#include "blobs.hpp"
#include<iostream>

//namespaces
using namespace cv; //avoid using 'cv' to declare OpenCV functions and variables (cv::Mat or Mat)
using namespace std;

//Definitions for Measurement extraction
#define MIN_WIDTH 9
#define MIN_HEIGHT 11

//main function
int main(int argc, char ** argv)
{
	int count=0;		 											// frame counter
	Mat frame;														// frame of the video sequence
	Mat initial_frame = cv::Mat::zeros(cv::Size(1,500), CV_64FC1);	// initial frame of the video sequence
	int first_measure = 0;

	//abandonedBox_600_1000_clip.mp4 | boats_6950_7900_clip.mp4 | pedestrians_800_1025_clip.mp4 | streetCornerAtNight_0_100_clip.mp4
	std::string inputvideo = "/home/avsa/Desktop/dataset_lab3/lab3.3/abandonedBox_600_1000_clip.mp4"; 	// path for the video to process

	char mode[] = "cteAcceleration"; // Choose between the mode with cteVelocity and cteAcceleration

	//alternatively, the videofile can be passed via arguments of the executable
	if (argc == 3) inputvideo = argv[1];
	VideoCapture cap(inputvideo);							// reader to grab frames from video

	//check if videofile exists
	if (!cap.isOpened())
		throw std::runtime_error("Could not open video file " + inputvideo); //throw error if not possible to read videofile

    int stateSize;
    int measSize;
    int contrSize;

    unsigned int type = CV_32F;


	//Definition of the KalmanFilter class
	if (strcmp(mode,"cteVelocity")==0){


	    stateSize = 4;
	    measSize = 2;
	    contrSize = 0;

	}
	else{

	    stateSize = 6;
	    measSize = 2;
	    contrSize = 0;

	}

	//Definition of the KalmanFilter class
	cv::KalmanFilter kf(stateSize, measSize, contrSize, type);

    int PROCNOISECOV_DEF1 = 25;
    int PROCNOISECOV_DEF2 = 1;

    int MEASNOISECOV_DEF = 25;

    //Definition of the KalmanFilter matrices

	if (strcmp(mode,"cteVelocity")==0){

	    //A matrix (Transition Matrix)
	    kf.transitionMatrix = (Mat_<float>(stateSize,stateSize) << 1,1,0,0,  0,1,0,0,  0,0,1,1,  0,0,0,1);

	    //H matrix (Observation Matrix)
	    kf.measurementMatrix = (Mat_<float>(measSize,stateSize) << 1,0,0,0,  0,0,1,0);

	    //Q matrix (Covariance of Process Noise)
	    cv::setIdentity(kf.processNoiseCov, cv::Scalar(10));
	    kf.processNoiseCov.at<float>(0) = PROCNOISECOV_DEF1;
	    kf.processNoiseCov.at<float>(10) = PROCNOISECOV_DEF1;

	    //cout << "C = " << endl << " " << kf.processNoiseCov << endl << endl;

	    //R matrix (Covariance of Observation Noise)
	    cv::setIdentity(kf.measurementNoiseCov, cv::Scalar(MEASNOISECOV_DEF));

	    //P pre matrix (Error covariance) (Covariance of Observation Noise)
	    cv::setIdentity(kf.errorCovPre, cv::Scalar(1e5));
	}
	else{


	    //A matrix (Transition Matrix)
	    kf.transitionMatrix = (Mat_<float>(stateSize,stateSize) << 1,1,0.5,0,0,0,  0,1,1,0,0,0,  0,0,1,0,0,0,  0,0,0,1,1,0.5,  0,0,0,0,1,1,  0,0,0,0,0,1);

	    //H matrix (Observation Matrix)
	    kf.measurementMatrix = (Mat_<float>(measSize,stateSize) << 1,0,0,0,0,0,  0,0,0,1,0,0);

	    //Q matrix (Covariance of Process Noise)
	    cv::setIdentity(kf.processNoiseCov, cv::Scalar(10));
	    kf.processNoiseCov.at<float>(0) = PROCNOISECOV_DEF1;
	    kf.processNoiseCov.at<float>(14) = PROCNOISECOV_DEF2;
	    kf.processNoiseCov.at<float>(21) = PROCNOISECOV_DEF1;
	    kf.processNoiseCov.at<float>(35) = PROCNOISECOV_DEF2;


	    //cout << "C = " << endl << " " << kf.processNoiseCov << endl << endl;

	    //R matrix (Covariance of Observation Noise)
	    cv::setIdentity(kf.measurementNoiseCov, cv::Scalar(MEASNOISECOV_DEF));

	    //P pre matrix (Error covariance) (Covariance of Observation Noise)
	    cv::setIdentity(kf.errorCovPre, cv::Scalar(1e5));


	}

	//Variables needed for Measurement extraction

	//Initializing the MOG2 model
	Ptr<BackgroundSubtractor> pMOG2 = cv::createBackgroundSubtractorMOG2();

	std::vector<cvBlob> bloblist; // list for blobs
	std::vector<cvBlob> bloblistFiltered; // list for filtered  blobs

	Mat fgmask;
	Mat _frame;
	Mat blob_image;
	Point c;
	Mat struct_ele = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(4,5)); //structuring element for morphological operations
	int learning_rate = 0.01;
	Mat dst;

	//Variables needed for prediction and correction
    cv::Mat state(stateSize, 1, type);  // [x,v_x,y,v_y] or [x,v_x,a_x,y,v_y,a_y] depending on the mode
    cv::Mat measurements(measSize, 1, type);    // [z_x,z_y]
    cv::Mat correction;

    std::vector<cv::Point> Correction_vector;



	//main loop
	for (int i=0;true;i++) {

		std::cout << "FRAME " << std::setfill('0') << std::setw(3) << ++count << std::endl; //print frame number

		//get frame & check if we achieved the end of the videofile (e.g. frame.data is empty)
		cap >> frame;
		if (!frame.data)
			break;


		if (i==0){

			frame.copyTo(initial_frame);
		}

		//copying original frame
		_frame=frame.clone();

		//converting to grayscale for further operations
		cv::cvtColor(_frame, _frame, CV_BGR2GRAY);
		// Smoothing the noise, so that we can get a nice foreground mask
		cv::GaussianBlur(_frame, _frame, cv::Size(5, 5), 0);

		// Applying MOG2 function to obtain the foreground mask
		pMOG2->apply(_frame, fgmask,learning_rate);

		//fgmask= fgmask > 254;
		// thresholding the image
		cv::threshold(fgmask, dst, 250, 255, cv::THRESH_BINARY);
		//Using morphological operation,Opening of Image to enhance the target object
		cv::erode(dst, dst, struct_ele);
		cv::dilate(dst, dst, struct_ele);


	   //======================================

	    int connectivity = 8; // 4 or 8

	    // Extract the blobs in fgmask using the connected component analysis
	    extractBlobs(dst, bloblist, connectivity);
				//cout << "Num blobs extracted=" << bloblist.size() << endl;
	    // Function to Remove blobs smaller than 10X10 pixel
	    removeSmallBlobs(bloblist, bloblistFiltered, MIN_WIDTH, MIN_HEIGHT);
				//cout<< "Num small blobs removed=" << bloblist.size()-bloblistFiltered.size() << endl;

		// Painting the final blob over the image
		blob_image=paintBlobImage(frame,bloblistFiltered, true);
		c=blobPosition(bloblistFiltered);

    	if (c.x == 0 && c.y == 0)
    	{
    		c.x=-100; c.y =-100;
    	}


		//get measurement from preloaded list of measurements
		cv::Point meas = c;

		//do kalman-based tracking
		//PLACE YOUR CODE HERE
		//...
		//...

		cv::Point correction_point;


		measurements.at<float>(0) = meas.x;
		measurements.at<float>(1) = meas.y;

		cout << "Measurements before correcting:" << endl << measurements << endl;

		// mode: cteVelocity
		if (strcmp(mode,"cteVelocity")==0){

			//If statement depending if there's a measurement or not
			if (meas.x != -100 && meas.y != -100){

				//If the measurement is the first initialize the Kalman Filter
				if (first_measure == 0){

					kf.statePre.at<float>(0)= meas.x;
					kf.statePre.at<float>(1)= 0;
					kf.statePre.at<float>(2)= meas.y;
					kf.statePre.at<float>(3)= 0;

					kf.statePost.at<float>(0)= meas.x;
					kf.statePost.at<float>(1)= 0;
					kf.statePost.at<float>(2)= meas.y;
					kf.statePost.at<float>(3)= 0;

					correction = kf.correct(measurements);

					correction_point.x = correction.at<float>(0);
					correction_point.y = correction.at<float>(2);

					first_measure = 1;


				}

				//If the measurement is not the first
				else{

					state = kf.predict();

					correction = kf.correct(measurements);

					correction_point.x = correction.at<float>(0);
					correction_point.y = correction.at<float>(2);

				}

			}

			//If there's is no measurement
			else{

				//If the first measurement didn't arrive yet
				if (first_measure == 0){

					correction_point.x = -100;
					correction_point.y = -100;

				}

				//If the first measurement already arrived
				else{

					state = kf.predict();

					correction_point.x = state.at<float>(0);
					correction_point.y = state.at<float>(2);

				}
			}
		}

		//mode: cteAcceleration
		else{

			//If statement depending if there's a measurement or not
			if (meas.x != -100 && meas.y != -100){

				//If the measurement is the first initialize the Kalman Filter
				if (first_measure == 0){

					kf.statePre.at<float>(0)= meas.x;
					kf.statePre.at<float>(1)= 0;
					kf.statePre.at<float>(2)= 0;
					kf.statePre.at<float>(3)= meas.y;
					kf.statePre.at<float>(4)= 0;
					kf.statePre.at<float>(5)= 0;

					kf.statePost.at<float>(0)= meas.x;
					kf.statePost.at<float>(1)= 0;
					kf.statePost.at<float>(2)= 0;
					kf.statePost.at<float>(3)= meas.y;
					kf.statePost.at<float>(4)= 0;
					kf.statePost.at<float>(5)= 0;

					correction = kf.correct(measurements);

					correction_point.x = correction.at<float>(0);
					correction_point.y = correction.at<float>(3);

					first_measure = 1;

				}

				//If the measurement is not the first
				else{

					state = kf.predict();

					correction = kf.correct(measurements);

					correction_point.x = correction.at<float>(0);
					correction_point.y = correction.at<float>(3);
				}
			}

			//If there's is no measurement
			else{

				//If the first measurement didn't arrive yet
				if (first_measure == 0){

					correction_point.x = -100;
					correction_point.y = -100;

				}

				//If the first measurement already arrived
				else{

					state = kf.predict();

					correction_point.x = state.at<float>(0);
					correction_point.y = state.at<float>(3);

				}
			}
		}


		cout << "State Correction:" << endl << correction_point << endl;


		//display frame (YOU MAY ADD YOUR OWN VISUALIZATION FOR MEASUREMENTS, AND THE STAGES IMPLEMENTED)
		std::ostringstream str;
		str << std::setfill('0') << std::setw(3) << count;
		putText(frame,"Frame " + str.str(), cvPoint(30,30),FONT_HERSHEY_COMPLEX_SMALL, 0.8, cvScalar(255,255,255), 1, CV_AA);
		drawMarker(frame, meas, cvScalar(255,0,0), MARKER_CROSS, 20,2); //display measurement
		drawMarker(frame, correction_point, cvScalar(0,255,0), MARKER_STAR, 20,2); //display the prediction corrected
		imshow("Frame ",frame);

		//cancel execution by pressing "ESC"
		if( (char)waitKey(100) == 27)
			break;


		// Draw the trajectory for the measurements and the estimations
		circle(initial_frame, meas, 5, cvScalar(255,0,0),1,8);
		circle(initial_frame, correction_point, 5, cvScalar(0,0,255),1,8);
		putText(initial_frame,"Measurement z_k ", cvPoint(30,30),FONT_HERSHEY_COMPLEX_SMALL, 0.8, cvScalar(255,0,0), 1, CV_AA);
		putText(initial_frame,"Estimated x_k ", cvPoint(30,50),FONT_HERSHEY_COMPLEX_SMALL, 0.8, cvScalar(0,0,255), 1, CV_AA);
		imshow("Trajectory ",initial_frame);


	}

	printf("Finished program.");
	destroyAllWindows(); 	// closes all the windows

	return 0;
}


