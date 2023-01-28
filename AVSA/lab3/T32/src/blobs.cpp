/* Applied Video Analysis of Sequences (AVSA)
 *
 *	LAB2: Blob detection & classification
 *	Lab2.0: Sample Opencv project
 *
 *
 * Authors: José M. Martínez (josem.martinez@uam.es), Paula Moral (paula.moral@uam.es), Juan C. San Miguel (juancarlos.sanmiguel@uam.es)
 */
#include <iostream>
#include "blobs.hpp"
using namespace std;

/**
 *	Draws blobs with different rectangles on the image 'frame'. All the input arguments must be
 *  initialized when using this function.
 *
 * \param frame Input image
 * \param pBlobList List to store the blobs found
 * \param labelled - true write label and color bb, false does not wirite label nor color bb
 *
 * \return Image containing the draw blobs. If no blobs have to be painted
 *  or arguments are wrong, the function returns a copy of the original "frame".
 *
 */
Mat paintBlobImage(cv::Mat frame, std::vector<cvBlob> bloblist, bool labelled)
{
	cv::Mat blobImage;
	//check input conditions and return original if any is not satisfied
	//...
	frame.copyTo(blobImage);

	//required variables to paint
	//...
	Point c;// int X; int Y;
	//paint each blob of the list
	for(int i = 0; i < bloblist.size(); i++)
	{
		cvBlob blob = bloblist[i]; //get ith blob
		//...
		Scalar color = Scalar(0, 0, 255); Scalar color_1 = Scalar(255, 255, 255);
		std::string label="Ball";


		Point p1 = Point(blob.x, blob.y);
		Point p2 = Point(blob.x+blob.w, blob.y+blob.h);
		c = Point((blob.x+blob.w)/2,(blob.y+blob.h)/2);
		 //X=(blob.x+blob.w)/2; Y=(blob.y+blob.h)/2;
		//cout<<"x"<<blob.x <<endl;cout<<"y"<<blob.y <<endl;cout<<"w"<<blob.w <<endl;cout<<"h"<<blob.h <<endl;

		//cout << "Blob Center:"<< c << endl;
		rectangle(blobImage, p1, p2, color, 2, 8, 0);


	}

	//destroy all resources (if required)
	//...

	//return the image to show
	return blobImage;
}
Point blobPosition (std::vector<cvBlob> bloblist)
{
	Point c;
for(int i = 0; i < bloblist.size(); i++)
	{
		cvBlob blob = bloblist[i]; //get ith blob
		//...
		Point p1 = Point(blob.x, blob.y);
		Point p2 = Point(blob.x+blob.w, blob.y+blob.h);
		c = Point((blob.x+blob.w/2),(blob.y+blob.h/2));

}

return c;

}

/**
 *	Blob extraction from 1-channel image (binary). The extraction is performed based
 *	on the analysis of the connected components. All the input arguments must be 
 *  initialized when using this function.
 *
 * \param fgmask Foreground/Background segmentation mask (1-channel binary image) 
 * \param bloblist List with found blobs
 *
 * \return Operation code (negative if not succesfull operation) 
 */
int extractBlobs(cv::Mat fgmask, std::vector<cvBlob> &bloblist, int connectivity)
{	
	//check input conditions and return -1 if any is not satisfied
	//...		

	//required variables for connected component analysis 
	//...
	Mat aux; // image to be updated each time a blob is detected (blob cleared)
	//fgmask.convertTo(aux,CV_32SC1);
	aux=fgmask.clone();
	//clear blob list (to fill with this function)
	bloblist.clear();
			
	//Connected component analysis
	
	int blobID = 1;

	for (int i = 0; i < aux.rows; i++){

	    for (int j = 0; j < aux.cols; j++){

	    	if (aux.at<uchar>(i,j) == 255){

	    		//cv::Rect bb;
	    		//int num_color = 64;
	    		//int flags = connectivity;
	    		Point seed = Point(j,i);

	    		cv::Rect rect;


	    		cv::floodFill(aux, seed, 64, &rect,0,0, connectivity);
	    	//	cout << "Floodfill" << endl ;
	    		cvBlob blob=initBlob(blobID, rect.x, rect.y, rect.width, rect.height);
	    		bloblist.push_back(blob);
	    		blobID = blobID + 1;

	    	}
	    }
	}


//	std::cout << bkg << " " << fg << " " << sh <<" " << fill << " " << unknown << " "<< bkg+fg+sh+unknown  << " " << fgmask.rows*fgmask.cols << std::endl;
//	std::cout << blob_id << " " << small_blobs << std::endl;

	//destroy all resources
	//...

	//return OK code
	return 1;

}


int removeSmallBlobs(std::vector<cvBlob> bloblist_in, std::vector<cvBlob> &bloblist_out, int min_width, int min_height)
{
	//check input conditions and return -1 if any is not satisfied

	//required variables
	//...

	//clear blob list (to fill with this function)
	bloblist_out.clear();

	int sz=  bloblist_in.size();

	for(int i = 0; i <sz; i++)
	{
		cvBlob blob_in = bloblist_in[i]; //get ith blob

		//IF YOU WANT TO CHECK ONLY THE FIRE-GRASS ALGORITHM COMMENT
		//From here

		if ((blob_in.w * blob_in.h) >= (min_width*min_height)){

			bloblist_out.push_back(blob_in);
		}



		//To here
		// ...

		//IF YOU WANT TO CHECK ONLY THE FIRE-GRASS ALGORITHM UNCOMMENT NEXT LINE
		//bloblist_out.push_back(blob_in); // void implementation (does not remove)



	}
	//destroy all resources
	//...
	
	//return OK code
	return 1;
}





