/* Applied Video Sequence Analysis - Escuela Politecnica Superior - Universidad Autonoma de Madrid
 *
 *	This source code belongs to the template code for
 *	the assignment LAB 4 "Histogram-based tracking"
 *
 *	Implementation of utilities for LAB4.
 *
 * Author: Juan C. SanMiguel (juancarlos.sanmiguel@uam.es)
 * Date: April 2020
 */
#include <opencv2/opencv.hpp>
#include "utils.hpp"

using namespace cv;
using namespace std;

/**
 * Reads a text file where each row contains comma separated values of
 * corners of groundtruth bounding boxes.
 *
 * The annotations are stored in a text file with the format:
 * Row format is "X1, Y1, X2, Y2, X3, Y3, X4, Y4" where Xi and Yi are
 * the coordinates of corner i of the bounding box in frame N, which
 * corresponds to the N-th row in the text file.
 *
 * Returns a list of cv::Rect with the bounding boxes data.
 *
 * @param ground_truth_path: full path to ground truth text file
 * @return bbox_list: list of ground truth bounding boxes of class Rect
 */
std::vector<Rect> readGroundTruthFile(std::string groundtruth_path)
				{
	// variables for reading text file
	ifstream inFile; //file stream
	string bbox_values; //line of file containing all bounding box data
	string bbox_value;  //a single value of bbox_values

	vector<Rect> bbox_list; //output with all read bounding boxes

	// open text file
	inFile.open(groundtruth_path.c_str(),ifstream::in);
	if(!inFile)
		throw runtime_error("Could not open groundtrutfile " + groundtruth_path); //throw error if not possible to read file

	// Read each line of groundtruth file
	while(getline(inFile, bbox_values)){

		stringstream linestream(bbox_values); //convert read line to linestream
		//cout << "-->lineread=" << linestream.str() << endl;

		// Read comma separated values of groundtruth.txt
		vector<int> x_values,y_values; 	//values to be read from line
		int line_ctr = 0;						//control variable to read alternate Xi,Yi
		while(getline(linestream, bbox_value, ',')){

			//read alternate Xi,Yi coordinates
			if(line_ctr%2 == 0)
				x_values.push_back(stoi(bbox_value));
			else
				y_values.push_back(stoi(bbox_value));
			line_ctr++;
		}

		// Get width and height; and minimum X,Y coordinates
		double xmin = *min_element(x_values.begin(), x_values.end()); //x coordinate of the top-left corner
		double ymin = *min_element(y_values.begin(), y_values.end()); //y coordinate of the top-left corner

		if (xmin < 0) xmin=0;
		if (ymin < 0) ymin=0;

		double width = *max_element(x_values.begin(), x_values.end()) - xmin; //width
		double height = *max_element(y_values.begin(), y_values.end()) - ymin;//height

		// Initialize a cv::Rect for a bounding box and store it in a std<vector> list
		bbox_list.push_back(Rect(xmin, ymin, width, height));
		//std::cout << "-->Bbox=" << bbox_list[bbox_list.size()-1] << std::endl;
	}
	inFile.close();

	return bbox_list;
				}

/**
 * Compare two lists of bounding boxes to estimate their overlap
 * using the criterion IOU (Intersection Over Union), which ranges
 * from 0 (worst) to 1(best) as described in the following paper:
 * Čehovin, L., Leonardis, A., & Kristan, M. (2016).
 * Visual object tracking performance measures revisited.
 * IEEE Transactions on Image Processing, 25(3), 1261-1274.
 *
 * Returns a list of floats with the IOU for each frame.
 *
 * @param Bbox_GT: list of elements of type cv::Rect describing
 * 				   the groundtruth bounding box of the object for each frame.
 * @param Bbox_est: list of elements of type cv::Rect describing
 * 				   the estimated bounding box of the object for each frame.
 * @return score: list of float values (IOU values) for each frame
 *
 * Comments:
 * 		- The two lists of bounding boxes must be aligned, meaning that
 * 		position 'i' for both lists corresponds to frame 'i'.
 * 		- Only estimated Bboxes are compared, so groundtruth Bbox can be
 * 		a list larger than the list of estimated Bboxes.
 */
std::vector<float> estimateTrackingPerformance(std::vector<cv::Rect> Bbox_GT, std::vector<cv::Rect> Bbox_est)
				{
	vector<float> score;

	//For each data, we compute the IOU criteria for all estimations
	for(int f=0;f<(int)Bbox_est.size();f++)
	{
		Rect m_inter = Bbox_GT[f] & Bbox_est[f];//Intersection
		Rect m_union = Bbox_GT[f] | Bbox_est[f];//Union

		score.push_back((float)m_inter.area()/(float)m_union.area());
	}

	return score;
				}

//OUR FUNCTIONS

std::vector<Rect> Create_Candidates(int grid_size,  Rect prediction, int step, int Width, int Height)
				{

	vector<Rect> candidates;

	for (int i=-grid_size; i<=grid_size; i++){

		for (int j=-grid_size; j<=grid_size; j++){

			candidates.push_back(Rect(prediction.x+(i*step),prediction.y+(j*step),Width,Height));  // creating the probable candidates using the grid size and STEP
		}

	}

	return candidates;
				}

std::vector<Mat> Compute_Candidates_Histograms(Mat frame,  vector<Rect> Candidates, int histSize ,string feature,char clr_channel, bool HOG_feature){

	vector<Mat> Candidates_histograms;
	vector<Mat> channel;
	Mat cand_image,_cand_image,disp_img,gray_region_image,H_region_image;

	for (int i=0; i<Candidates.size(); i++){

		Mat cand_histogram;

		if (Candidates[i].x >= 0 && Candidates[i].y >= 0 && Candidates[i].x + Candidates[i].width <= frame.cols && Candidates[i].y + Candidates[i].height <= frame.rows){

			cand_image=frame(Candidates[i]);  // getting candidates region from the frame
			cand_image.copyTo(_cand_image);  // copying the region image
			cvtColor(cand_image,gray_region_image,COLOR_BGR2GRAY); // converting the candidate image to gray scale for processing in gray scale


			if (feature == "RGB"){
				split(_cand_image,channel);  // splitting the color image into RGB
				switch (clr_channel)
				{
				case 'B': // for Blue channel
					disp_img=channel[0];
					cand_histogram = displayHistogram(disp_img, histSize,feature,clr_channel); // calculating the histogram for blue channel
					//cout<< "B"<<endl;

					break ;
				case 'G': // For Green channel
					disp_img=channel[1];
					cand_histogram = displayHistogram(disp_img, histSize,feature,clr_channel); // calculating the histogram for green channel
					//cout<< "G cand"<<endl;

					break;
				case 'R':  // for Red channel
					disp_img=channel[2];
					cand_histogram = displayHistogram(disp_img, histSize,feature,clr_channel);  // calculating the histogram for red channel
					//cout<< "R"<<endl;

					break;
				default: cout << "Error: Please choose correct value" << endl; break;
				}
			}

			else if(feature == "HSV"){
				cvtColor(_cand_image, H_region_image, COLOR_BGR2HSV); // BGR to HSV conversion using Opencv function
				split(H_region_image,channel); // spliting the HSV planes
				switch(clr_channel)
				{	case 'H': // for Hue
					disp_img=channel[0];
					cand_histogram = displayHistogram(disp_img, histSize,feature,clr_channel);  // calculating the histogram for Hue
					//cout << "H"<<endl;

					break;
				case 'S': // for saturation
					disp_img=channel[1];
					cand_histogram = displayHistogram(disp_img, histSize,feature,clr_channel);  // calculating the histogram for Saturation

					//cout <<"S"<<endl;

					break;

				default: cout << "Error: Please choose correct value" << endl; break;
				}
			}
			else if(HOG_feature == false){
				// for Gray value

				disp_img=gray_region_image;
				cand_histogram = displayHistogram(disp_img, histSize,feature,clr_channel);   // calculating the histogram for gray feature
				//cout << "gray" << endl;
			}

			// HOG features will be calculated only for gray scale
			if(HOG_feature == true)
			{
				disp_img=gray_region_image;
				//model_hist = displayHistogram(disp_img, histSize,feature,clr_channel);

				cand_histogram=computeHOG(disp_img,histSize); // function to compute the HOG feature
				//hog_histImage = displayhogHistogram (hog_img,histSize) ; // function to visualize HOG feature
				//cout << "HOG" << endl;
			}

			Candidates_histograms.push_back(cand_histogram);  // pushing back the candidate histogram

		}

	}
return Candidates_histograms;

}

std::vector<float> Compare_Model_Candidates(Mat model, vector<Mat> candidates_histogram)
				{

	vector<float> distances;

	for (int i=0; i<candidates_histogram.size(); i++){

		double result = compareHist( model, candidates_histogram[i], CV_COMP_BHATTACHARYYA );  //computing bhatacharaya distance between the model and candidates.

		distances.push_back(result);


	}

	return distances;
				}

int Find_Lowest_Distance(vector<float> distances)
{

	int Num_Candidate = std::min_element(distances.begin(),distances.end()) - distances.begin();  // finding the candidate with minimum bhattacharya distance.

	return Num_Candidate;

}

Mat computeHOG(Mat ROI,int histSize ) // Function to compute the HOG features
{
	HOGDescriptor hog;
	vector<float> descriptor; // HOG Feature vector.
	resize(ROI,ROI,Size(64,128)); // resizing img to 64X128.
	hog.nbins=histSize;
	hog.compute(ROI,descriptor);   //computing HOG feature
	Mat hog_img = Mat(descriptor).clone();

	// to normalize the HOG histogram
	int hist_w = 512, hist_h = 400;
	int bin_w = cvRound( (double) hist_w/histSize );
	Mat hog_histImage( hist_h, hist_w, CV_8UC3, Scalar( 255,255,255) );
	normalize(hog_img, hog_img, 0, hog_histImage.rows, NORM_MINMAX, -1, Mat() );  // normalizing the HOG Feature histogram

	return hog_img; // return the HOG feature Histogram

}

Mat displayHistogram(Mat channel,int histSize,string feature ,char clr) //Function to compute the Histograms for R,G,B,H,S,Gray
{
	Mat hist;
	float range[] = { 0, 256 }; //the upper boundary is exclusive
	const float* histRange = { range };
	bool uniform = true, accumulate = false;
	int hist_w = 512, hist_h = 400;
	int bin_w = cvRound( (double) hist_w/histSize );
	Mat histImage( hist_h, hist_w, CV_8UC3, Scalar( 0,0,0) );
	Scalar color;
	if (clr=='B' && feature == "RGB"){  color=Scalar( 255, 0, 0); }
	else if (clr=='G' && feature == "RGB"){  color=Scalar( 0,255, 0); }
	else if (clr=='R' && feature == "RGB"){  color=Scalar( 0,0,255); }
	else{  color=Scalar( 255,255, 255); }

	calcHist(&channel, 1, 0, Mat(), hist, 1, &histSize, &histRange, uniform, accumulate); // calculating the histogram

	normalize(hist, hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );  // normalizing the histogram

	//	for( int i = 1; i < histSize; i++ )
	//	{line( histImage, Point( bin_w*(i-1), hist_h - cvRound(hist.at<float>(i-1)) ),
	//			Point( bin_w*(i), hist_h - cvRound(hist.at<float>(i)) ),
	//			color, 2, 8, 0  );}
	return hist;
}



