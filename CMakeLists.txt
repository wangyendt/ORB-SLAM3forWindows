cmake_minimum_required(VERSION 2.8)
project(ORB_SLAM3)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Debug)
ENDIF()

MESSAGE("Build type: " ${CMAKE_BUILD_TYPE})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -W0 -MT -bigobj")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -W0 -MT -bigobj")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -Wall   -O3")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall   -O3")
#set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -march=native")
#set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -march=native")

# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-deprecated -O3 -march=native ")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-deprecated -O3 -march=native")

# Check C++11 or C++0x support
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
   add_definitions(-DCOMPILEDWITHC11)
   message(STATUS "Using flag -std=c++11.")
elseif(COMPILER_SUPPORTS_CXX0X)
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
   add_definitions(-DCOMPILEDWITHC0X)
   message(STATUS "Using flag -std=c++0x.")
#else()
#   message(FATAL_ERROR "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()

LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake_modules)

set(OpenCV_DIR $ENV{OPENCV3_PATH})

find_package(OpenCV 3 REQUIRED)
if(NOT OpenCV_FOUND)
   find_package(OpenCV 2.4.3 QUIET)
   if(NOT OpenCV_FOUND)
      message(FATAL_ERROR "OpenCV > 2.4.3 not found.")
   endif()
endif()

MESSAGE("OPENCV VERSION:")
MESSAGE(${OpenCV_VERSION})

find_package(Eigen3 3.1.0 REQUIRED)
find_package(Pangolin REQUIRED)

include_directories(
${PROJECT_SOURCE_DIR}
${PROJECT_SOURCE_DIR}/include
${PROJECT_SOURCE_DIR}/include/CameraModels
${EIGEN3_INCLUDE_DIR}
${Pangolin_INCLUDE_DIRS}
$ENV{BOOST_PATH}
)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

add_library(${PROJECT_NAME} STATIC
src/System.cc
src/Tracking.cc
src/LocalMapping.cc
src/LoopClosing.cc
src/ORBextractor.cc
src/ORBmatcher.cc
src/FrameDrawer.cc
src/Converter.cc
src/MapPoint.cc
src/KeyFrame.cc
src/Atlas.cc
src/Map.cc
src/MapDrawer.cc
src/Optimizer.cc
src/PnPsolver.cc
src/Frame.cc
src/KeyFrameDatabase.cc
src/Sim3Solver.cc
src/Initializer.cc
src/Viewer.cc
src/ImuTypes.cc
src/G2oTypes.cc
src/CameraModels/Pinhole.cpp
src/CameraModels/KannalaBrandt8.cpp
src/OptimizableTypes.cpp
src/MLPnPsolver.cpp
include/System.h
include/Tracking.h
include/LocalMapping.h
include/LoopClosing.h
include/ORBextractor.h
include/ORBmatcher.h
include/FrameDrawer.h
include/Converter.h
include/MapPoint.h
include/KeyFrame.h
include/Atlas.h
include/Map.h
include/MapDrawer.h
include/Optimizer.h
include/PnPsolver.h
include/Frame.h
include/KeyFrameDatabase.h
include/Sim3Solver.h
include/Initializer.h
include/Viewer.h
include/ImuTypes.h
include/G2oTypes.h
include/CameraModels/GeometricCamera.h
include/CameraModels/Pinhole.h
include/CameraModels/KannalaBrandt8.h
include/OptimizableTypes.h
include/MLPnPsolver.h
include/TwoViewReconstruction.h
src/TwoViewReconstruction.cc)

#add_subdirectory(Thirdparty/g2o)

target_link_libraries(${PROJECT_NAME}
${OpenCV_LIBS}
${EIGEN3_LIBS}
${Pangolin_LIBRARIES}
${PROJECT_SOURCE_DIR}/Thirdparty/DBoW2/lib/${CMAKE_BUILD_TYPE}/DBoW2.lib
${PROJECT_SOURCE_DIR}/Thirdparty/g2o/lib/${CMAKE_BUILD_TYPE}/g2o.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
#-lboost_serialization
#-lcrypto
)

if(MSVC)     
    # Use the static C library for all build types
    foreach(var 
        CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE
        CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO
        CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO
      )
      if(${var} MATCHES "/MD")
        string(REGEX REPLACE "/MD" "/MT" ${var} "${${var}}")
      endif()
    endforeach()    
endif(MSVC)

target_compile_definitions( ${PROJECT_NAME} PRIVATE COMPILEDWITHC11 )

# Build examples

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/RGB-D)
add_executable(rgbd_tum
Examples/RGB-D/rgbd_tum.cc)
target_compile_definitions( rgbd_tum PRIVATE COMPILEDWITHC11 )
target_link_libraries(rgbd_tum 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Stereo)

add_executable(stereo_kitti
Examples/Stereo/stereo_kitti.cc)
target_compile_definitions( stereo_kitti PRIVATE COMPILEDWITHC11 )
target_link_libraries(stereo_kitti 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)

add_executable(stereo_euroc
Examples/Stereo/stereo_euroc.cc)
target_compile_definitions( stereo_euroc PRIVATE COMPILEDWITHC11 )
target_link_libraries(stereo_euroc 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)

add_executable(stereo_tum_vi
Examples/Stereo/stereo_tum_vi.cc)
target_compile_definitions( stereo_tum_vi PRIVATE COMPILEDWITHC11 )
target_link_libraries(stereo_tum_vi 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Monocular)

add_executable(mono_tum
Examples/Monocular/mono_tum.cc)
target_compile_definitions( mono_tum PRIVATE COMPILEDWITHC11 )
target_link_libraries(mono_tum 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)

add_executable(mono_kitti
Examples/Monocular/mono_kitti.cc)
target_compile_definitions( mono_kitti PRIVATE COMPILEDWITHC11 )
target_link_libraries(mono_kitti 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)

add_executable(mono_euroc
Examples/Monocular/mono_euroc.cc)
target_compile_definitions( mono_euroc PRIVATE COMPILEDWITHC11 )
target_link_libraries(mono_euroc 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)

add_executable(mono_tum_vi
Examples/Monocular/mono_tum_vi.cc)
target_compile_definitions( mono_tum_vi PRIVATE COMPILEDWITHC11 )
target_link_libraries(mono_tum_vi 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Monocular-Inertial)

add_executable(mono_inertial_euroc
Examples/Monocular-Inertial/mono_inertial_euroc.cc)
target_compile_definitions( mono_inertial_euroc PRIVATE COMPILEDWITHC11 )
target_link_libraries(mono_inertial_euroc 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)

add_executable(mono_inertial_tum_vi
Examples/Monocular-Inertial/mono_inertial_tum_vi.cc)
target_compile_definitions( mono_inertial_tum_vi PRIVATE COMPILEDWITHC11 )
target_link_libraries(mono_inertial_tum_vi 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Stereo-Inertial)

add_executable(stereo_inertial_euroc
Examples/Stereo-Inertial/stereo_inertial_euroc.cc)
target_compile_definitions( stereo_inertial_euroc PRIVATE COMPILEDWITHC11 )
target_link_libraries(stereo_inertial_euroc 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)


add_executable(stereo_inertial_tum_vi
Examples/Stereo-Inertial/stereo_inertial_tum_vi.cc)
target_compile_definitions( stereo_inertial_tum_vi PRIVATE COMPILEDWITHC11 )
target_link_libraries(stereo_inertial_tum_vi 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/Examples/Android-Phone)

add_executable(mono_android_mate20
Examples/Android-Phone/mono_android_mate20.cc)
target_compile_definitions( mono_android_mate20 PRIVATE COMPILEDWITHC11 )
target_link_libraries(mono_android_mate20 
${PROJECT_NAME}
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-sgd-x64-1_79.lib
$ENV{BOOST_PATH}/stage/lib/libboost_serialization-vc143-mt-s-x64-1_79.lib
)

