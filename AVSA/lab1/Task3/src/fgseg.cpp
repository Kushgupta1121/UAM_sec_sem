/* Applied Video Sequence Analysis (AVSA)
 *
 *	LAB1.0: Background Subtraction - Unix version
 *	fgesg.cpp
 *
 * 	Authors: José M. Martínez (josem.martinez@uam.es), Paula Moral (paula.moral@uam.es) & Juan Carlos San Miguel (juancarlos.sanmiguel@uam.es)
 *	VPULab-UAM 2020
 */

#include <opencv2/opencv.hpp>
#include "fgseg.hpp"


using namespace fgseg;

//default constructor
/*
bgs::bgs(double threshold, bool rgb)
{
	_rgb=rgb;

	_threshold=threshold;
}
*/
//Constructor for the three tasks
bgs::bgs(double threshold, double alpha, bool selective_bkg_update, bool rgb, int threshold_ghosts2)
{
	_rgb=rgb;

	_threshold=threshold;

	_alpha=alpha;

	_selective_bkg_update=selective_bkg_update;

	_threshold_ghosts2 = threshold_ghosts2;
}
//default destructor
bgs::~bgs(void)
{
}

//method to initialize bkg (first frame - hot start)
void bgs::init_bkg(cv::Mat Frame)
{

	if (!_rgb){
		cvtColor(Frame, Frame, COLOR_BGR2GRAY); // to work with gray even if input is color

		_bkg = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix
		//ADD YOUR CODE HERE
		//imshow("BKG", _bkg);
		Frame.copyTo(_bkg);


	}
	else{

		_bkg = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC3); // void function for Lab1.0 - returns zero matrix
		//ADD YOUR CODE HERE
		Frame.copyTo(_bkg);
		//imshow("BKG_def", _bkg);

	}

}

//method to perform BackGroundSubtraction for Lab111
void bgs::bkgSubtraction(cv::Mat Frame)
{

	if (!_rgb){
		cvtColor(Frame, Frame, COLOR_BGR2GRAY); // to work with gray even if input is color
		Frame.copyTo(_frame);

		_diff = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix
		_bgsmask = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix
		//ADD YOUR CODE HERE
		//...
		_diff = abs(_frame - _bkg);

		_bgsmask = _diff >_threshold;




		//...
	}
	else{

		Frame.copyTo(_frame);

		_diff = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC3); // void function for Lab1.0 - returns zero matrix
		_bgsmask = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC3); // void function for Lab1.0 - returns zero matrix
		//ADD YOUR CODE HERE
		//...
		_diff = abs(_frame - _bkg);

		_bgsmask = _diff >_threshold;

	    }

}

//method to perform BackGroundSubtraction for Lab112
void bgs::bkgSubtraction_Lab112(cv::Mat Frame)
{

	if (!_rgb){
		cvtColor(Frame, Frame, COLOR_BGR2GRAY); // to work with gray even if input is color
		Frame.copyTo(_frame);

		_diff = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix
		_bgsmask = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix


		//cout << _bgsmask << "\n\n\n" << endl;
		_bkg = (_alpha*_frame) + (1-_alpha)*_bkg;
		_diff = abs(_frame - _bkg);
		_bgsmask = _diff > _threshold;

		if (_selective_bkg_update == true){

			for (int i = 0; i < Frame.rows; i++){

			    for (int j = 0; j < Frame.cols; j++){

			        if (_bgsmask.at<uchar>(i,j) == 0){//(_bgsmask.at<uchar>(i,j) == 255)

			        	_bkg.at<uchar>(i,j) = _frame.at<uchar>(i,j);

			        }


			    }
			}


		}

		//...
	}
	else{
		Frame.copyTo(_frame);

		_diff = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC3); // void function for Lab1.0 - returns zero matrix
		_bgsmask = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC3); // void function for Lab1.0 - returns zero matrix

		_bkg = (_alpha*_frame) + (1-_alpha)*_bkg;
		_diff = abs(_frame - _bkg);
		//cout << _bgsmask << "\n\n\n"<< endl;
		_bgsmask = _diff > _threshold;


		if (_selective_bkg_update == true){

			Mat bgsmask_planes[3];
			Mat bkg_planes[3];
			Mat frame_planes[3];

			split(_bgsmask, bgsmask_planes);
			split(_bkg, bkg_planes);
			split(_frame, frame_planes);


			for (int i = 0; i < Frame.rows; i++){

			    for (int j = 0; j < Frame.cols; j++){

			        if (bgsmask_planes[0].at<uchar>(i,j) == 0){//(_bgsmask.at<uchar>(i,j) == 255)

			        	bkg_planes[0].at<uchar>(i,j) = frame_planes[0].at<uchar>(i,j);

			        }

			        if (bgsmask_planes[1].at<uchar>(i,j) == 0){//(_bgsmask.at<uchar>(i,j) == 255)

			        	bkg_planes[1].at<uchar>(i,j) = frame_planes[1].at<uchar>(i,j);

			        }

			        if (bgsmask_planes[2].at<uchar>(i,j) == 0){//(_bgsmask.at<uchar>(i,j) == 255)

			        	bkg_planes[2].at<uchar>(i,j) = frame_planes[2].at<uchar>(i,j);

			        }
			    }
			}

		    vector<Mat> channels_bgsmask;
		    vector<Mat> channels_bkg;

		    channels_bgsmask.push_back(bgsmask_planes[0]);
		    channels_bgsmask.push_back(bgsmask_planes[1]);
		    channels_bgsmask.push_back(bgsmask_planes[2]);

		    channels_bkg.push_back(bkg_planes[0]);
		    channels_bkg.push_back(bkg_planes[1]);
		    channels_bkg.push_back(bkg_planes[2]);

			merge(channels_bgsmask, _bgsmask);
			merge(channels_bkg, _bkg);

		}
	}
}

//method to perform BackGroundSubtraction for Lab113
cv::Mat bgs::bkgSubtraction_Lab113(cv::Mat Frame, cv::Mat mat_counter)
{

	if (!_rgb){

		cvtColor(Frame, Frame, COLOR_BGR2GRAY);
		Frame.copyTo(_frame);

		_diff = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix
		_bgsmask = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix
		//ADD YOUR CODE HERE

		_bkg = (_alpha*_frame) + (1-_alpha)*_bkg;
		_diff = abs(_frame - _bkg);

		_bgsmask = _diff > _threshold;

		for (int i = 0; i < Frame.rows; i++){

			for (int j = 0; j < Frame.cols; j++){

				if (_bgsmask.at<uchar>(i,j) == 255){//(_bgsmask.at<uchar>(i,j) == 255)

					mat_counter.at<uchar>(i,j) = mat_counter.at<uchar>(i,j) + 1;

					if (mat_counter.at<uchar>(i,j) >= _threshold_ghosts2){

						_bkg.at<uchar>(i,j) = _frame.at<uchar>(i,j);

					}


				}
				else{

					mat_counter.at<uchar>(i,j) = 0;
				}
			}
		}
	}

	else{

		Frame.copyTo(_frame);

		_diff = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix
		_bgsmask = Mat::zeros(Size(Frame.cols,Frame.rows), CV_8UC1); // void function for Lab1.0 - returns zero matrix
		//ADD YOUR CODE HERE

		_bkg = (_alpha*_frame) + (1-_alpha)*_bkg;
		_diff = abs(_frame - _bkg);

		_bgsmask = _diff > _threshold;


		Mat bgsmask_planes[3];
		Mat bkg_planes[3];
		Mat frame_planes[3];

		split(_bgsmask, bgsmask_planes);
		split(_bkg, bkg_planes);
		split(_frame, frame_planes);

		Mat mat_counter_planes[3];
		split(mat_counter, mat_counter_planes);


		for (int i = 0; i < Frame.rows; i++)
		{
		    for (int j = 0; j < Frame.cols; j++)
		    {

		    	for (int z = 0; z<3; z++){

					if (bgsmask_planes[z].at<uchar>(i,j) == 255){//(_bgsmask.at<uchar>(i,j) == 255)

						mat_counter_planes[z].at<uchar>(i,j) = mat_counter_planes[z].at<uchar>(i,j) + 1;

						if (mat_counter_planes[z].at<uchar>(i,j) >= _threshold_ghosts2){

							bkg_planes[z].at<uchar>(i,j) = frame_planes[z].at<uchar>(i,j);

						}


					}

					else{

						mat_counter_planes[z].at<uchar>(i,j) = 0;
					}

		    	}


		    }
		}

	    vector<Mat> channels_bgsmask;
	    vector<Mat> channels_bkg;

	    channels_bgsmask.push_back(bgsmask_planes[0]);
	    channels_bgsmask.push_back(bgsmask_planes[1]);
	    channels_bgsmask.push_back(bgsmask_planes[2]);

	    channels_bkg.push_back(bkg_planes[0]);
	    channels_bkg.push_back(bkg_planes[1]);
	    channels_bkg.push_back(bkg_planes[2]);

	    vector<Mat> channels_mat_counter;
	    channels_mat_counter.push_back(mat_counter_planes[0]);
	    channels_mat_counter.push_back(mat_counter_planes[1]);
	    channels_mat_counter.push_back(mat_counter_planes[2]);

		merge(channels_bgsmask, _bgsmask);
		merge(channels_bkg, _bkg);

		merge(channels_mat_counter, mat_counter);

	}


	return mat_counter;
}

//method to detect and remove shadows in the BGS mask to create FG mask
void bgs::removeShadows()
{
	// init Shadow Mask (currently Shadow Detection not implemented)
	//_bgsmask.copyTo(_shadowmask); // creates the mask (currently with bgs)
	_shadowmask = Mat::zeros(Size(_frame.cols,_frame.rows), CV_8UC1);

	//ADD YOUR CODE HERE
	//...
	cv::Mat Frame_HSV;

	cvtColor(_frame, Frame_HSV, CV_BGR2HSV); // to work with gray even if input is color

	Mat bgsmask_planes_shadow[3];
	Mat bkg_planes_shadow[3];
	Mat frame_HSV_planes_shadow[3];

	split(_bgsmask, bgsmask_planes_shadow);
	split(_bkg, bkg_planes_shadow);
	split(_frame, frame_HSV_planes_shadow);

	double alpha_shadow = 0.5;
	double beta_shadow = 0.9;
	double saturation_shadow_th = 80;
	double hue_shadow_th = 70;

	for (int i = 0; i < Frame_HSV.rows; i++){

	    for (int j = 0; j < Frame_HSV.cols; j++){

	    	double pixel_frame_H = frame_HSV_planes_shadow[0].at<uchar>(i,j);
	    	double pixel_frame_S = frame_HSV_planes_shadow[1].at<uchar>(i,j);
	    	double pixel_frame_V = frame_HSV_planes_shadow[2].at<uchar>(i,j);

	    	double pixel_bkg_H = bkg_planes_shadow[0].at<uchar>(i,j);
	    	double pixel_bkg_S = bkg_planes_shadow[1].at<uchar>(i,j);
	    	double pixel_bkg_V = bkg_planes_shadow[2].at<uchar>(i,j);

	    	double Dh = min(abs(pixel_frame_H - pixel_bkg_H), 360 - abs(pixel_frame_H - pixel_bkg_H));

	    	double Hue_division = pixel_frame_V/pixel_bkg_V;
	    	double Saturation_substraction = abs(pixel_frame_S - pixel_bkg_S);

	    	if (alpha_shadow <= Hue_division && Hue_division <= beta_shadow && Saturation_substraction <= saturation_shadow_th && Dh <= hue_shadow_th){

	    		_shadowmask.at<uchar>(i,j) = 255;


	    	}

	    }

	}

	//absdiff(_bgsmask, _bgsmask, _shadowmask);// currently void function mask=0 (should create shadow mask)
	//...
	cvtColor(_bgsmask,_bgsmask,CV_RGB2GRAY);




	absdiff(_bgsmask, _shadowmask, _fgmask); // eliminates shadows from bgsmask
}

//ADD ADDITIONAL FUNCTIONS HERE




