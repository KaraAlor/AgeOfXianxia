@echo off
set DIR=".."
if "%1"=="" goto :make
set DIR=%1
:make
make -C %DIR% all