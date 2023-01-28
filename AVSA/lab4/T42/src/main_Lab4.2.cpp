/* Applied Video Sequence Analysis - Escuela Politecnica Superior - Universidad Autonoma de Madrid
 *
 *	This source code belongs to the template (sample program)
 *	provided for the assignment LAB 4 "Histogram-based tracking"
 *
 *	This code has been tested using:
 *	- Operative System: Ubuntu 18.04
 *	- OpenCV version: 3.4.4
 *	- Eclipse version: 2019-12
 *
 * Author: Juan C. SanMiguel (juancarlos.sanmiguel@uam.es)
 * Date: April 2020
 */
//includes
#include <stdio.h> 								//Standard I/O library
#include <numeric>								//For std::accumulate function
#include <string> 								//For std::to_string function
#include <opencv2/opencv.hpp>					//opencv libraries
#include "utils.hpp" 							//for functions readGroundTruthFile & estimateTrackingPerformance

//namespaces
using namespace cv;
using namespace std;

//Definition of the grid
#define GRID_SIZE 1 //1,2,3,4,5,6,7,8,9...
#define STEP 5

//#define CTE_WIDTH 30
//#define CTE_HEIGHT 30

//main function
int main(int argc, char ** argv)
{
	//PLEASE CHANGE 'dataset_path' & 'output_path' ACCORDING TO YOUR PROJECT
	std::string dataset_path = "/home/avsa/Desktop/Dataset_Lab4/";									//dataset location.
	std::string output_path = "/home/avsa/eclipse-workspace/Lab4.2/outvideos/";									//location to save output videos
	//std::string dataset_path = "/home/avsa/eclipse-workspace/kush_lab4.2/src/datasets";
	// dataset paths
	std::string sequences[] = {"bolt1",										//test data for lab4.1b
	};
	/*
	std::string sequences[] = {"bolt1",										//test data for lab4.1, 4.3 & 4.5
							   "sphere","car1",								//test data for lab4.2
							   "ball2","basketball",						//test data for lab4.4
							   "bag","ball","road",};						//test data for lab4.6
	 */
	std::string image_path = "%08d.jpg"; 									//format of frames. DO NOT CHANGE
	std::string groundtruth_file = "groundtruth.txt"; 						//file for ground truth data. DO NOT CHANGE
	int NumSeq = sizeof(sequences)/sizeof(sequences[0]);					//number of sequences

	//------------------------------------------------------------------------------
	string feature = "GR"; // GR for GRAY, RGB or HSV
	char clr_channel= 'G'; // If feature = RGB, then choose b/w R or G or B else is Feature= HSV then choose from H or S
	int histSize = 32; // Number of bins can be modified here
	bool HOG_feature = false;    // for HOG feature set this to true and select feature = GR
	Mat model_image,_model_image,gray_region_image,disp_img,H_region_image;
	vector<Mat> channel;
	//-------------------------------------------------------------------------------

	//Loop for all sequence of each category
	for (int s=0; s<NumSeq; s++ )
	{
		Mat frame;										//current Frame
		int frame_idx=0;								//index of current Frame
		std::vector<Rect> list_bbox_est, list_bbox_gt;	//estimated & groundtruth bounding boxes
		std::vector<double> procTimes;					//vector to accumulate processing times

		std::string inputvideo = dataset_path + "/" + sequences[s] + "/img/" + image_path; //path of videofile. DO NOT CHANGE
		VideoCapture cap(inputvideo);	// reader to grab frames from videofile

		//check if videofile exists
		if (!cap.isOpened())
			throw std::runtime_error("Could not open video file " + inputvideo); //error if not possible to read videofile

		// Define the codec and create VideoWriter object.The output is stored in 'outcpp.avi' file.
		cv::Size frame_size(cap.get(cv::CAP_PROP_FRAME_WIDTH),cap.get(cv::CAP_PROP_FRAME_HEIGHT));//cv::Size frame_size(700,460);
		VideoWriter outputvideo(output_path+"outvid_" + sequences[s]+".avi",CV_FOURCC('X','V','I','D'),10, frame_size);	//xvid compression (cannot be changed in OpenCV)

		//Read ground truth file and store bounding boxes
		std::string inputGroundtruth = dataset_path + "/" + sequences[s] + "/" + groundtruth_file;//path of groundtruth file. DO NOT CHANGE
		list_bbox_gt = readGroundTruthFile(inputGroundtruth); //read groundtruth bounding boxes

		Rect prediction = list_bbox_gt[0];

		//Definition of the model
		Rect model_Rect = list_bbox_gt[0];
		Mat model_hist;

		int Width = model_Rect.width;
		int Height = model_Rect.height;


		//main loop for the sequence
		std::cout << "Displaying sequence at " << inputvideo << std::endl;
		std::cout << "  with groundtruth at " << inputGroundtruth << std::endl;
		for (;;) {
			//get frame & check if we achieved the end of the videofile (e.g. frame.data is empty)
			cap >> frame;
			if (!frame.data)
				break;

			//Time measurement
			double t = (double)getTickCount();
			frame_idx=cap.get(cv::CAP_PROP_POS_FRAMES);			//get the current frame

			////////////////////////////////////////////////////////////////////////////////////////////
			//DO TRACKING
			//Change the following line with your own code
			//list_bbox_est.push_back(Rect(20,20,40,50));//we use a fixed value only for this demo program. Remove this line when you use your code
			//...
			// ADD YOUR CODE HERE
			//...
			////////////////////////////////////////////////////////////////////////////////////////////
			//----------------------------------------------------------------------------------



			// to initalize the model histogram
			model_image=frame(model_Rect);
			//model_image=frame(Range(y,y+Height),Range(x,x+Width));
			model_image.copyTo(_model_image);  // copying the region image to remove the green border
			cvtColor(_model_image,gray_region_image,COLOR_BGR2GRAY);

			if (frame_idx == 1){

				if (feature == "RGB"){
					split(_model_image,channel);
					switch (clr_channel)
					{
					case 'B': // for Blue channel
						disp_img=channel[0];
						model_hist = displayHistogram(disp_img, histSize,feature,clr_channel);
						cout<< "B"<<endl;

						break ;
					case 'G': // For Green channel
						disp_img=channel[1];
						model_hist = displayHistogram(disp_img, histSize,feature,clr_channel);
						cout<< "G model"<<endl;

						break;
					case 'R':  // for Red channel
						disp_img=channel[2];
						model_hist = displayHistogram(disp_img, histSize,feature,clr_channel);
						cout<< "R"<<endl;

						break;
					default: cout << "Error: Please choose correct value" << endl; break;
					}
				}

				else if(feature == "HSV"){
					cvtColor(_model_image, H_region_image, COLOR_BGR2HSV); // BGR to HSV conversion using Opencv function
					split(H_region_image,channel); // spliting the HSV planes
					switch(clr_channel)
					{	case 'H': // for Hue
						disp_img=channel[0];
						model_hist = displayHistogram(disp_img, histSize,feature,clr_channel);
						cout << "H"<<endl;

						break;
					case 'S': // for saturation
						disp_img=channel[1];
						model_hist = displayHistogram(disp_img, histSize,feature,clr_channel);

						cout <<"S"<<endl;

						break;

					default: cout << "Error: Please choose correct value" << endl; break;
					}
				}
				else if(HOG_feature == false){
					// for Gray value

					disp_img=gray_region_image;
					model_hist = displayHistogram(disp_img, histSize,feature,clr_channel);
					cout << "gray" << endl;
				}

				// HOG features will be calculated only for gray scale
				if(HOG_feature == true)
				{
					disp_img=gray_region_image;
					//model_hist = displayHistogram(disp_img, histSize,feature,clr_channel);

					model_hist=computeHOG(disp_img,histSize); // function to compute the HOG feature
					//hog_histImage = displayhogHistogram (hog_img,histSize) ; // function to visualize HOG feature
					cout << "HOG";
				}



			}


			//Create candidates
			vector<Rect> Candidates = Create_Candidates(GRID_SIZE, prediction, STEP, Width, Height);

			// Compute the histogram of the candidates

			vector<Mat> Candidates_histograms = Compute_Candidates_Histograms(frame, Candidates,histSize,feature,clr_channel,HOG_feature);



			//Compare the model and the candidates
			vector<float> Distances = Compare_Model_Candidates(model_hist, Candidates_histograms);

			//Find the index of the best candidate
			int Num_Candidate = Find_Lowest_Distance(Distances);

			//Using the best candidate as the estimation
			list_bbox_est.push_back(Candidates[Num_Candidate]);

			prediction = Candidates[Num_Candidate];



			//Time measurement
			procTimes.push_back(((double)getTickCount() - t)*1000. / cv::getTickFrequency());
			//std::cout << " processing time=" << procTimes[procTimes.size()-1] << " ms" << std::endl;

			// plot frame number & groundtruth bounding box for each frame
			putText(frame, std::to_string(frame_idx), cv::Point(10,15),FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0, 0, 255)); //text in red
			rectangle(frame, list_bbox_gt[frame_idx-1], Scalar(0, 255, 0));		//draw bounding box for groundtruth
			rectangle(frame, list_bbox_est[frame_idx-1], Scalar(0, 0, 255));	//draw bounding box (estimation)

			//show & save data
			imshow("Tracking for "+sequences[s]+" (Green=GT, Red=Estimation)", frame);
			outputvideo.write(frame);//save frame to output video

			//exit if ESC key is pressed
			if(waitKey(30) == 27) break;
		}

		//comparison groundtruth & estimation
		vector<float> trackPerf = estimateTrackingPerformance(list_bbox_gt, list_bbox_est);

		//print stats about processing time and tracking performance
		std::cout << "  Average processing time = " << std::accumulate( procTimes.begin(), procTimes.end(), 0.0) / procTimes.size() << " ms/frame" << std::endl;
		std::cout << "  Average tracking performance = " << std::accumulate( trackPerf.begin(), trackPerf.end(), 0.0) / trackPerf.size() << std::endl;

		//release all resources
		cap.release();			// close inputvideo
		outputvideo.release(); 	// close outputvideo
		destroyAllWindows(); 	// close all the windows
	}
	printf("Finished program.");
	return 0;
}



