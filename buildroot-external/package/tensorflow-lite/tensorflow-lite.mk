################################################################################
#
# tensorflow-lite
#
################################################################################

TENSORFLOW_LITE_VERSION = 2.11.0
TENSORFLOW_LITE_SITE =  $(call github,tensorflow,tensorflow,v$(TENSORFLOW_LITE_VERSION))
TENSORFLOW_LITE_INSTALL_STAGING = YES
TENSORFLOW_LITE_LICENSE = Apache-2.0
TENSORFLOW_LITE_LICENSE_FILES = LICENSE
TENSORFLOW_LITE_SUBDIR = tensorflow/lite
TENSORFLOW_LITE_SUPPORTS_IN_SOURCE_BUILD = NO
TENSORFLOW_LITE_DEPENDENCIES += \
	host-pkgconf \
	host-flatbuffers \
	cpuinfo \
	eigen \
	farmhash \
	fft2d \
	flatbuffers \
	gemmlowp \
	libabseil-cpp \
	neon-2-sse

TENSORFLOW_LITE_CONF_OPTS = \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -funsafe-math-optimizations \
		-I$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR) \
		-I$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/numpy/core/include \
		-I$(STAGING_DIR)/usr/include/pybind11 \
		-I$(STAGING_DIR)/usr/include/gemmlowp" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -funsafe-math-optimizations \
		-I$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR) \
		-I$(STAGING_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/numpy/core/include \
		-I$(STAGING_DIR)/usr/include/pybind11 \
		-I$(STAGING_DIR)/usr/include/gemmlowp" \
	-Dabsl_DIR=$(STAGING_DIR)/usr/lib/cmake/absl \
	-DBUILD_SHARED_LIBS=ON \
	-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON \
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	-DEigen3_DIR=$(STAGING_DIR)/usr/share/eigen3/cmake \
	-DFETCHCONTENT_FULLY_DISCONNECTED=ON \
	-DFETCHCONTENT_QUIET=OFF \
	-DFFT2D_SOURCE_DIR=$(STAGING_DIR)/usr/include/fft2d \
	-DFlatBuffers_DIR=$(STAGING_DIR)/usr/lib/cmake/flatbuffers \
	-DNEON_2_SSE_DIR=$(STAGING_DIR)/usr/lib/cmake/NEON_2_SSE \
	-DSYSTEM_FARMHASH=ON \
	-DTFLITE_ENABLE_EXTERNAL_DELEGATE=ON \
	-DTFLITE_ENABLE_GPU=OFF \
	-DTFLITE_ENABLE_INSTALL=ON \
	-DTFLITE_ENABLE_MMAP=ON \
	-DTFLITE_ENABLE_NNAPI=OFF

ifeq ($(BR2_PACKAGE_RUY),y)
TENSORFLOW_LITE_DEPENDENCIES += ruy
TENSORFLOW_LITE_CONF_OPTS += -DTFLITE_ENABLE_RUY=ON
else
TENSORFLOW_LITE_CONF_OPTS += -DTFLITE_ENABLE_RUY=OFF
endif

ifeq ($(BR2_PACKAGE_XNNPACK),y)
TENSORFLOW_LITE_DEPENDENCIES += xnnpack
TENSORFLOW_LITE_CONF_OPTS += -DTFLITE_ENABLE_XNNPACK=ON -Dxnnpack_POPULATED=ON
else
TENSORFLOW_LITE_CONF_OPTS += -DTFLITE_ENABLE_XNNPACK=OFF
endif

TENSORFLOW_LITE_MAKE_OPTS += _pywrap_tensorflow_interpreter_wrapper benchmark_model

TENSORFLOW_LITE_POST_INSTALL_STAGING_HOOKS = TENSORFLOW_LITE_INSTALL_VERSION_HEADER

TENSORFLOW_LITE_POST_INSTALL_TARGET_HOOKS = TENSORFLOW_LITE_INSTALL_TFLITE_RUNTIME

define TENSORFLOW_LITE_INSTALL_VERSION_HEADER
	mkdir -p  $(STAGING_DIR)/usr/include/tensorflow/core/public
	$(INSTALL) -D -m 644  $(@D)/tensorflow/core/public/version.h \
		$(STAGING_DIR)/usr/include/tensorflow/core/public/
endef

define TENSORFLOW_LITE_INSTALL_TFLITE_RUNTIME

	mkdir -p $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime
	mkdir -p $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime-${TENSORFLOW_LITE_VERSION}-py$(PYTHON3_VERSION_MAJOR).egg-info

	$(INSTALL) -D -m 755 $(@D)/$(TENSORFLOW_LITE_SUBDIR)/buildroot-build/_pywrap_tensorflow_interpreter_wrapper.so \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime/

	$(INSTALL) -D -m 755 $(@D)/$(TENSORFLOW_LITE_SUBDIR)/python/interpreter.py \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime/

	$(INSTALL) -D -m 755 $(@D)/$(TENSORFLOW_LITE_SUBDIR)/python/metrics/metrics_interface.py \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime/

	$(INSTALL) -D -m 755 $(@D)/$(TENSORFLOW_LITE_SUBDIR)/python/metrics/metrics_portable.py \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime/

	$(INSTALL) -D -m 755 $(BR2_EXTERNAL_OPENVOICEOS_PATH)/package/tensorflow-lite/tflite_runtime/__init__.py \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime/

	$(INSTALL) -D -m 755 $(BR2_EXTERNAL_OPENVOICEOS_PATH)/package/tensorflow-lite/tflite_runtime/MANIFEST.in \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime/

	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_OPENVOICEOS_PATH)/package/tensorflow-lite/tflite_runtime/dependency_links.txt \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime-${TENSORFLOW_LITE_VERSION}-py$(PYTHON3_VERSION_MAJOR).egg-info/

	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_OPENVOICEOS_PATH)/package/tensorflow-lite/tflite_runtime/PKG-INFO \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime-${TENSORFLOW_LITE_VERSION}-py$(PYTHON3_VERSION_MAJOR).egg-info/

	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_OPENVOICEOS_PATH)/package/tensorflow-lite/tflite_runtime/requires.txt \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime-${TENSORFLOW_LITE_VERSION}-py$(PYTHON3_VERSION_MAJOR).egg-info/

	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_OPENVOICEOS_PATH)/package/tensorflow-lite/tflite_runtime/SOURCES.txt \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime-${TENSORFLOW_LITE_VERSION}-py$(PYTHON3_VERSION_MAJOR).egg-info/

	$(INSTALL) -D -m 644 $(BR2_EXTERNAL_OPENVOICEOS_PATH)/package/tensorflow-lite/tflite_runtime/top_level.txt \
		$(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/tflite_runtime-${TENSORFLOW_LITE_VERSION}-py$(PYTHON3_VERSION_MAJOR).egg-info/

endef

$(eval $(cmake-package))
