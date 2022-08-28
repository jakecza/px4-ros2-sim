cmake_minimum_required(VERSION 3.5)

project(px4_ros2_sim)

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic -fpermissive)
endif()

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_action REQUIRED)
find_package(std_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(nav_msgs REQUIRED)
find_package(px4_msgs REQUIRED)


add_executable(${PROJECT_NAME}

)

ament_target_dependencies(${PROJECT_NAME}
  "rclcpp"
  "rclcpp_action"
  "std_msgs"
  "sensor_msgs"
  "nav_msgs"
  "px4_msgs"
)

install(  TARGETS
            ${PROJECT_NAME}
          DESTINATION
            lib/${PROJECT_NAME}
)

# if(BUILD_TESTING)
#   # Linting
#   find_package(ament_lint_auto REQUIRED)
#   ament_lint_auto_find_test_dependencies()

#   find_package(ament_cmake_gtest REQUIRED)
#   set(TEST_PKG TEST_PKG)
#   ament_add_gtest_executable(${TEST_PKG}
#   
#   )
#   target_include_directories(${TEST_PKG} PRIVATE
#     ${CMAKE_SOURCE_DIR}
#   )
#   if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
#     target_compile_options(${TEST_PKG} PRIVATE -Wall -Wextra)
#   endif()
#   ament_target_dependencies(${TEST_PKG}
#     "rclcpp"
#     "rclcpp_action"
#     "std_msgs"
#     "sensor_msgs"
#     "nav_msgs"
#     "px4_msgs"
#   )
# endif()  # BUILD_TESTING

ament_package()
