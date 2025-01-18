cmake_minimum_required(VERSION 3.20)
find_package(Zephyr)
project(windy-sandbox)
target_sources(app PRIVATE src/main.c)
