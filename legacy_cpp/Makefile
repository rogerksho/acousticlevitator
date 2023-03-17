# C++ compiler
CXX = g++
CXXFLAGS = -std=c++1z -Wconversion -Wall -Werror -Wextra -pedantic 

# sources
SOURCES = $(wildcard *.cpp)
EXECUTABLE  = ultrasonic_controller
OBJECTS     = $(SOURCES:%.cpp=%.o)

# make debug
debug: CXXFLAGS += -g3 -DDEBUG
debug:
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(EXECUTABLE)_debug

# make syntax
syntax: CXXFLAGS += -Wno-unused-parameter -Wno-unused-variable
syntax:
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(EXECUTABLE)_syntax

# make clean
clean:
	rm -f $(OBJECTS) $(EXECUTABLE) $(EXECUTABLE)_debug $(EXECUTABLE)_syntax
	rm -Rf *.dSYM