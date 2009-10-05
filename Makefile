
#CXXFLAGS	:= -D_DEBUG_VALUES -D_DEBUG -DHAVE_NUMPY -I../vamp-plugin-sdk -O2 -Wall -I/usr/include/python2.5 -I/Library/Frameworks/Python.framework/Versions/2.5/lib/python2.5/site-packages/numpy/core/include/numpy/ 
CXXFLAGS	:= -D_DEBUG -DHAVE_NUMPY -I../vamp-plugin-sdk -O2 -Wall -I/usr/include/python2.5 -I/Library/Frameworks/Python.framework/Versions/2.5/lib/python2.5/site-packages/numpy/core/include/
#CXXFLAGS	:= -DHAVE_NUMPY -I../vamp-plugin-sdk -O2 -Wall -I/usr/include/python2.5 -I/Library/Frameworks/Python.framework/Versions/2.5/lib/python2.5/site-packages/numpy/core/include/numpy/ 

#without numpy headers available:
#CXXFLAGS	:= -I../vamp-plugin-sdk -O2 -Wall -I/usr/include/python2.5  #-I../host/pyRealTime.h 
LDFLAGS		:= -L../vamp-plugin-sdk/vamp-sdk -lvamp-sdk -dynamiclib -lpython2.5 -lpthread

default: vampy.dylib 
all: vampy.dylib vampymod.so

PyExtensionModule.a: PyExtensionModule.o PyRealTime.o PyFeature.o PyParameterDescriptor.o PyOutputDescriptor.o PyFeatureSet.o 
	libtool -static $^ -o $@ 

# The standard python extension is .so (even on the Mac)
vampymod.so: PyExtensionModule.o PyRealTime.o PyFeature.o PyParameterDescriptor.o PyOutputDescriptor.o PyFeatureSet.o 
	g++ -shared $^ -o $@ $(LDFLAGS) 

vampy.dylib: PyPlugin.o PyPlugScanner.o vampy-main.o Mutex.o PyTypeInterface.o PyExtensionModule.a PyExtensionManager.o
	g++ -shared $^ -o $@ $(LDFLAGS) 

# Install plugin
#
LIBRARY_PREFIX		:=/Library
INSTALL_DIR			:=$(LIBRARY_PREFIX)/Audio/Plug-Ins/Vamp
PYEXAMPLE_DIR		:='Example VamPy Plugins'
PLUGIN_NAME			:=vampy
PLUGIN_EXT			:=.dylib
	
install:
	mkdir -p $(INSTALL_DIR)
	rm -f $(INSTALL_DIR)/$(PLUGIN_NAME)$(PLUGIN_EXT)
	cp $(PLUGIN_NAME)$(PLUGIN_EXT) $(INSTALL_DIR)/$(PLUGIN_NAME)$(PLUGIN_EXT)	
	#cp $(PYEXAMPLE_DIR)/*.py $(INSTALL_DIR)
	
installplug : install
cleanplug : clean

clean:	
	rm *.o
	rm *.a
	rm *$(PLUGIN_EXT)
	
