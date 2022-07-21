#include <iostream>
#include <string>
#include <sstream>
#include <time.h>
#include <windows.h>
// OpenCV includes
#include "opencv2/core.hpp"
#include "opencv2/highgui.hpp"
#include <opencv2/opencv.hpp>
using namespace cv;

long long getTimeMs()
{
	auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch());
	return ms.count();
}

int main() {
	VideoCapture cap;
	cap.open(0);
	if (!cap.isOpened()) {
		return -1;
	}
	double fps = cap.get(CV_CAP_PROP_FPS);
	std::cout << "Frames per second using video.get(CV_CAP_PROP_FPS) : " << fps << std::endl;
	//namedWindow("VideoWindow", 1);
	int nFrameUpdateFPS = 10;
	int curFrame = 0;
	long long start, end;
	struct timespec ts;
	for (;;) {
		Mat frame;
		cap >> frame;
		if (frame.empty()) {
			std::cout << "null frame" << std::endl;
		}
		if (curFrame < nFrameUpdateFPS) {
			++curFrame;
		}
		else if (curFrame == nFrameUpdateFPS) {
			end = getTimeMs();
			std::cout << "start=" << start << ", end=" << end << std::endl;
			auto seconds = difftime(end, start) / 1000;
			std::cout << "Time taken : " << seconds << " seconds" << std::endl;
			fps = nFrameUpdateFPS / (double)seconds;
			std::cout << "Estimated frames per second : " << fps << std::endl;
			curFrame = 0;
			start = getTimeMs();
		}
		//putText(frame,, new Point{0,0}, )
		auto s = std::format("fps={0:.2f}Hz", fps);
		putText(frame, s, Point(50, 50), FONT_HERSHEY_SIMPLEX, 1, Scalar(0, 0, 255), 1, 8, false);
		imshow("Video", frame);
		cvtColor(frame, frame, CV_BGR2GRAY);
		imshow("Gray", frame);
		//GaussianBlur(frame, frame, Size(7, 7), 1.5, 1.5);
		//imshow("Gaussian Blur", frame);
		Canny(frame, frame, 60, 100);
		imshow("Canny Edge", frame);
		if (waitKey(30) >= 0) {
			break;
		}
	}
	cap.release();
	return 0;
}