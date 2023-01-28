/* Applied Video Sequence Analysis (AVSA)
 *
 *	LAB1.0: Background Subtraction - Unix version
 *	fgesg.hpp
 *
 * 	Authors: José M. Martínez (josem.martinez@uam.es), Paula Moral (paula.moral@uam.es) & Juan Carlos San Miguel (juancarlos.sanmiguel@uam.es)
 *	VPULab-UAM 2020
 */


#include <opencv2/opencv.hpp>

#ifndef FGSEG_H_INCLUDE
#define FGSEG_H_INCLUDE

using namespace cv;
using namespace std;

namespace fgseg {


	//Declaration of FGSeg class based on BackGround Subtraction (bgs)
	class bgs{
	public:

		//constructor with parameter "threshold"
		//bgs(double threshold, bool rgb);

		//Constructor for Lab1.1.2
		bgs(double threshold, double alpha, bool selective_bkg_update, bool rgb, int threshold_ghosts2);

		//destructor
		~bgs(void);

		//method to initialize bkg (first frame - hot start)
		void init_bkg(cv::Mat Frame);

		//method to perform BackGroundSubtraction for Lab1.1.1
		void bkgSubtraction(cv::Mat Frame);

		//method to perform BackGroundSubtraction for Lab1.1.2
		void bkgSubtraction_Lab112(cv::Mat Frame);

		//method to perform BackGroundSubtraction for Lab1.1.3
		cv::Mat bkgSubtraction_Lab113(cv::Mat Frame, cv::Mat mat_counter);

		//method to detect and remove shadows in the binary BGS mask
		void removeShadows();

		//returns the BG image
		cv::Mat getBG(){return _bkg;};

		//returns the DIFF image
		cv::Mat getDiff(){return _diff;};

		//returns the BGS mask
		cv::Mat getBGSmask(){return _bgsmask;};

		//returns the binary mask with detected shadows
		cv::Mat getShadowMask(){return _shadowmask;};

		//returns the binary FG mask
		cv::Mat getFGmask(){return _fgmask;};


		//ADD ADITIONAL METHODS HERE
		//...
	private:
		cv::Mat _bkg; //Background model
		cv::Mat	_frame; //current frame
		cv::Mat _diff; //abs diff frame
		cv::Mat _bgsmask; //binary image for bgssub (FG)
		cv::Mat _shadowmask; //binary mask for detected shadows
		cv::Mat _fgmask; //binary image for foreground (FG)

		bool _rgb;

		double _threshold;
		//ADD ADITIONAL VARIABLES HERE

		double _alpha;

		double _selective_bkg_update;

		int _threshold_ghosts2;
		//...

	};//end of class bgs

}//end of namespace

#endif




