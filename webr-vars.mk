# Configure your local environment in this file. Make sure to set
# `WEBR_ROOT` to the root directory of the webR repo
-include ~/.webr-vars.mk

# Select emfc implementation
-include $(WEBR_ROOT)/tools/fortran.mk

R_VERSION = $(shell cat $(WEBR_ROOT)/R/R-VERSION)
R_SOURCE = $(WEBR_ROOT)/R/build/R-$(R_VERSION)
R_HOME = $(WEBR_ROOT)/wasm/R-$(R_VERSION)/lib/R

WASM_OPT ?= -Oz
WEBR_INCLUDES = -I$(R_SOURCE)/build/include -I$(R_SOURCE)/src/include
WEBR_LDFLAGS = -L$(WEBR_ROOT)/wasm/lib -L$(WEBR_ROOT)/wasm/R-$(R_VERSION)/lib/R/lib

EM_LIBS = -s USE_LIBPNG=1
EM_CXX_FIXES = -DRCPP_DEMANGLER_ENABLED=0 -D__STRICT_ANSI__
EM_CFLAGS = $(EM_LIBS) $(WEBR_INCLUDES) $(WASM_OPT)

# Needed because Emscripten's `dlopen()` calls seem to ignore the
# `local` flag?
C_VISIBILITY = -fvisibility=hidden
CXX_VISIBILITY = -fvisibility=hidden

CXX98 = em++
CXX11 = em++
CXX14 = em++
CXX17 = em++
CXX20 = em++
CC = emcc
CXX = em++
CFLAGS = -std=gnu11 $(EM_CFLAGS)
CXXFLAGS = -std=gnu++11 $(EM_CXX_FIXES) $(EM_CFLAGS)
CXX98FLAGS = -std=gnu++98 $(EM_CXX_FIXES) $(EM_CFLAGS)
CXX11FLAGS = -std=gnu++11 $(EM_CXX_FIXES) $(EM_CFLAGS)
CXX14FLAGS = -std=gnu++14 $(EM_CXX_FIXES) $(EM_CFLAGS)
CXX17FLAGS = -std=gnu++17 $(EM_CXX_FIXES) $(EM_CFLAGS)
CXX20FLAGS = -std=gnu++20 $(EM_CXX_FIXES) $(EM_CFLAGS)
LDFLAGS = -s SIDE_MODULE=1 -s WASM_BIGINT -s ASSERTIONS=1 $(WEBR_LDFLAGS) $(WASM_OPT)

FC = $(EMFC)
FLIBS = $(FORTRAN_WASM_LDADD)

AR = emar
ALL_CPPFLAGS = -DNDEBUG $(PKG_CPPFLAGS) $(CLINK_CPPFLAGS) $(CPPFLAGS)
ALL_FFLAGS =
ALL_FCFLAGS =

# Uncomment to show emscripten calls to clang for debugging
# CFLAGS += -v
# LDFLAGS += -v

# Clear up flags from $(R_HOME)/etc/Makeconf
override DYLIB_LD = $(CC)
override DYLIB_LDFLAGS = $(CFLAGS)
override DYLIB_LINK = $(DYLIB_LD) $(DYLIB_LDFLAGS) $(LDFLAGS)

override SHLIB_LDFLAGS =
override SHLIB_LINK = $(SHLIB_LD) $(SHLIB_LDFLAGS) $(LDFLAGS)

override FOUNDATION_LIBS =
override LIBINTL =

override LIBR =
override ALL_LIBS = $(PKG_LIBS) $(SHLIB_LIBADD) $(LIBR) $(LIBINTL)

override BLAS_LIBS = -L$(WEBR_LOCAL)/lib/R/lib -lRblas
override LAPACK_LIBS = -L$(WEBR_LOCAL)/lib/R/lib -lRlapack


# Print Makefile variable
.PHONY: print-%
print-%  : ; @echo $* = $($*)
