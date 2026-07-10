cmake_minimum_required(VERSION 3.20)
project(LLVMDeadStoreEliminator)

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH ${LLVM_CMAKE_DIR})
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(DSEPass MODULE DSEPass.cpp)

# On macOS, cmake's MODULE type defaults to .so — force .dylib so the plugin
# can be loaded with -load-pass-plugin=./libDSEPass.dylib as documented.
if(APPLE)
  set_target_properties(DSEPass PROPERTIES SUFFIX ".dylib")
endif()

# On macOS, undefined symbols in the plugin are resolved by opt/clang at
# load time, so don't try to link against LLVM libs directly.
target_link_libraries(DSEPass PRIVATE
  "$<$<PLATFORM_ID:Darwin>:-undefined dynamic_lookup>"
)
