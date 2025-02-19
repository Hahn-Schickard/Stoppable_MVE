cmake_minimum_required(VERSION 3.24.0)

#@+ ======================== User PROJECT_NAME configuration ============================
set(THIS Stoppable)
#@- =========================== END OF USER CONFIGURATION ===============================

project(${THIS} CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(INCLUDES_DIR "${PROJECT_SOURCE_DIR}/includes")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/cmake")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(VERBOSE_FILE_INCLUSION "Prints all included header files" ON)

include(GNUInstallDirs)
include(macros)
include(compiler_settings)

#@+ ====================== User CMAKE_OPTIONS configuration ========================
# User defined options and cmake variables are set here
#@- ===================== END OF USER CONFIGURATION ================================

#@+ ==================== User CMAKE_INCLUDES configuration =======================
# User defined cmake module includes go here
#@- ======================== END OF USER CONFIGURATION ============================

#@+ ======================== User PACKAGES configuration ===========================
find_package(Threads REQUIRED)
#@- ========================= END OF USER CONFIGURATION ============================


add_subdirectory(sources)
