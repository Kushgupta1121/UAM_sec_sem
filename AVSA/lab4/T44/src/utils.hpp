/* Applied Video Sequence Analysis - Escuela Politecnica Superior - Universidad Autonoma de Madrid
 *
 *	This source code belongs to the template code for
 *	the assignment LAB 4 "Histogram-based tracking"
 *
 *	Header of utilities for LAB4.
 *	Some of these functions are adapted from OpenSource
 *
 * Author: Juan C. SanMiguel (juancarlos.sanmiguel@uam.es)
 * Date: April 2020
 */
#ifndef UTILS_HPP_
#define UTILS_HPP_

#include <string> 		// for string class
#include <opencv2/opencv.hpp>

std::vector<cv::Rect> readGroundTruthFile(std::string groundtruth_path);
std::vector<float> estimateTrackingPerformance(std::vector<cv::Rect> Bbox_GT, std::vector<cv::Rect> Bbox_est);

//OUR FUNCTIONS
std::vector<cv::Rect> Create_Candidates(int grid_size, cv::Rect prediction, int step, int Width, int Height);
std::vector<cv::Mat> Compute_Candidates_Histograms(cv::Mat frame,  std::vector<cv::Rect> Candidates, int histSize , std::string feature,char clr_channel, bool HOG_feature); //KUSH
std::vector<float> Compare_Model_Candidates(cv::Mat model, std::vector<cv::Mat> candidates_histogram);
int Find_Lowest_Distance(std::vector<float> distances);

cv::Mat computeHOG(cv::Mat ROI,int histSize );
cv::Mat displayHistogram(cv::Mat channel, int histSize, std::string feature, char clr);
cv::Mat displayhogHistogram( cv::Mat hog_img ,int histSize );

#endif /* UTILS_HPP_ */
