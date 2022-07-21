cmake_minimum_required(VERSION 2.8)

project(hello_opencv)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
ENDIF()

set(OpenCV_DIR "D:/work/code/tools/opencv3.4.16/build")

find_package(OpenCV 3)
if(NOT OpenCV_FOUND)
   find_package(OpenCV 2.4.3 QUIET)
   if(NOT OpenCV_FOUND)
      message(FATAL_ERROR "OpenCV > 2.4.3 not found.")
   endif()
endif()

aux_source_directory(./ DIR_SRCS)
include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(${PROJECT_NAME} ./hello_opencv.cpp)

target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})
