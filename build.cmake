
if (CMAKE_SIZEOF_VOID_P MATCHES 8)
	MESSAGE( "Yes" )
else (CMAKE_SIZEOF_VOID_P MATCHES 8)
	MESSAGE( "No" )
endif (CMAKE_SIZEOF_VOID_P MATCHES 8)

OPTION(DEBUG "enable debug build" No)
OPTION(SDL "SDL support (will not work without)" Yes)
OPTION(OPENGL "OpenGL support" Yes)
OPTION(OGG "Ogg/Vorbis support" Yes)
OPTION(TREMOR "Tremor support" No)

IF (DEBUG)
	SET(CMAKE_BUILD_TYPE Debug)
ELSE (DEBUG)
	SET(CMAKE_BUILD_TYPE Release)
ENDIF (DEBUG)

# Platform specific things can be put here
# Compilers and other specific variables can be found here:
# http://www.cmake.org/Wiki/CMake_Useful_Variables

SET(USRDIR /usr)
set(CMAKE_INCLUDE_PATH ${USRDIR})

# Compilation Flags and executables
IF (BUILD_TYPE STREQUAL GP2X OR
    BUILD_TYPE STREQUAL WIZ OR
    BUILD_TYPE STREQUAL CAANOO OR
    BUILD_TYPE STREQUAL DINGOO OR
    BUILD_TYPE STREQUAL PANDORA OR
    BUILD_TYPE STREQUAL NANONOTE)
	IF (BUILD_TYPE STREQUAL GP2X)
		SET(USRDIR /mythtv/media/devel/toolchains/open2x/gcc-4.1.1-glibc-2.3.6)
		SET(CMAKE_C_COMPILER ${USRDIR}/bin/arm-open2x-linux-gcc)
		SET(CMAKE_CXX_COMPILER ${USRDIR}/bin/arm-open2x-linux-g++)
		ADD_DEFINITIONS(-DGP2X)
		ADD_DEFINITIONS(-DNOKEYBOARD)
		SET(OGG Yes)
	ELSEIF(BUILD_TYPE STREQUAL WIZ)
		SET(USRDIR /mythtv/media/devel/toolchains/openwiz/arm-openwiz-linux-gnu)
		SET(CMAKE_C_COMPILER ${USRDIR}/bin/arm-openwiz-linux-gnu-gcc)
		SET(CMAKE_CXX_COMPILER ${USRDIR}/bin/arm-openwiz-linux-gnu-g++)
		ADD_DEFINITIONS(-DWIZ)
                ADD_DEFINITIONS(-DNOKEYBOARD)
		SET(OGG Yes)
        ELSEIF(BUILD_TYPE STREQUAL CAANOO)
                SET(USRDIR /mythtv/media/devel/toolchains/caanoo/GPH_SDK)
                SET(CMAKE_C_COMPILER ${USRDIR}/tools/gcc-4.2.4-glibc-2.7-eabi/bin/arm-gph-linux-gnueabi-gcc)
                SET(CMAKE_CXX_COMPILER ${USRDIR}/tools/gcc-4.2.4-glibc-2.7-eabi/bin/arm-gph-linux-gnueabi-g++)
                ADD_DEFINITIONS(-DCAANOO)
                SET(OGG Yes)

                include_directories(${USRDIR}/DGE/include)
                include_directories(${USRDIR}/DGE/include/SDL)
                include_directories(${USRDIR}/DGE/include/vorbis)
                link_directories(${USRDIR}/DGE/lib/target)
                ADD_DEFINITIONS(-DCAANOO)
                ADD_DEFINITIONS(-DNOKEYBOARD)
                SET(OGG Yes)
	ELSEIF(BUILD_TYPE STREQUAL DINGOO)
		SET(USRDIR /opt/mipsel-linux-uclibc/usr)
		SET(CMAKE_C_COMPILER ${USRDIR}/bin/mipsel-linux-uclibc-gcc)
		SET(CMAKE_CXX_COMPILER ${USRDIR}/bin/mipsel-linux-uclibc-g++)
                include_directories(${USRDIR}/DGE/include/tremor)
		ADD_DEFINITIONS(-DDINGOO)
                ADD_DEFINITIONS(-DNOKEYBOARD)
		SET(OGG No)
		SET(TREMOR Yes)
	ELSEIF(BUILD_TYPE STREQUAL PANDORA)
		SET(USRDIR /mythtv/media/devel/toolchains/pandora/arm-2007q3)
		SET(CMAKE_C_COMPILER ${USRDIR}/bin/arm-none-linux-gnueabi-gcc)
		SET(CMAKE_CXX_COMPILER ${USRDIR}/bin/arm-none-linux-gnueabi-g++)
		ADD_DEFINITIONS(-DPANDORA)
                ADD_DEFINITIONS(-mcpu=cortex-a8 -mtune=cortex-a8 -march=armv7-a)
                ADD_DEFINITIONS(-mfloat-abi=softfp -mfpu=neon -ftree-vectorize -fno-strict-aliasing -fsingle-precision-constant)

		SET(OGG Yes)
	ELSEIF(BUILD_TYPE STREQUAL NANONOTE)
		SET(USRDIR /usr/local/jlime/mipsel-toolchain/usr)
		SET(CMAKE_C_COMPILER ${USRDIR}/bin/mipsel-linux-gcc)
		SET(CMAKE_CXX_COMPILER ${USRDIR}/bin/mipsel-linux-g++)
		ADD_DEFINITIONS(-DNANONOTE)
		SET(OGG No)
		SET(TREMOR No)
	ENDIF(BUILD_TYPE STREQUAL GP2X)

	SET(BUILD_TYPE LINUX32)
	SET(CMAKE_SYSTEM_NAME Linux)
	SET(CMAKE_FIND_ROOT_PATH ${USRDIR})
	SET(CMAKE_INSTALL_USRDIR ${USRDIR})
	SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
	SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
	SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
	SET(CMAKE_FIND_LIBRARY_USRDIRES lib)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES .a)
	SET(OPENGL No)
	SET(CMAKE_VERBOSE_MAKEFILE ON)

	ADD_DEFINITIONS(-fsigned-char)
	ADD_DEFINITIONS(-ffast-math)
	ADD_DEFINITIONS(-fomit-frame-pointer)
        IF (NOT BUILD_TYPE STREQUAL CAANOO)
                include_directories(${USRDIR}/include)
                include_directories(${USRDIR}/include/vorbis)
                link_directories(${USRDIR}/lib)
        ENDIF (NOT BUILD_TYPE STREQUAL CAANOO)
ENDIF (BUILD_TYPE STREQUAL GP2X OR
    BUILD_TYPE STREQUAL WIZ OR
    BUILD_TYPE STREQUAL CAANOO OR
    BUILD_TYPE STREQUAL DINGOO OR
    BUILD_TYPE STREQUAL PANDORA OR
    BUILD_TYPE STREQUAL NANONOTE)

# Check wether in what system it is configured
IF(NOT HAVE_64_BIT AND BUILD_TYPE STREQUAL LINUX64)
	MESSAGE( "Warning: Building 64-bit Version on 32-bit machine is not supported!" )
ENDIF(NOT HAVE_64_BIT AND BUILD_TYPE STREQUAL LINUX64)


# Directory creation of all the builds
EXEC_PROGRAM(mkdir ARGS -p ${CMAKE_CURRENT_SOURCE_DIR}/build OUTPUT_VARIABLE NULL)
EXEC_PROGRAM(mkdir ARGS -p ${CMAKE_CURRENT_SOURCE_DIR}/build/Linux32 OUTPUT_VARIABLE NULL)
EXEC_PROGRAM(mkdir ARGS -p ${CMAKE_CURRENT_SOURCE_DIR}/build/Linux64 OUTPUT_VARIABLE NULL)
EXEC_PROGRAM(mkdir ARGS -p ${CMAKE_CURRENT_SOURCE_DIR}/build/Win32 OUTPUT_VARIABLE NULL)
EXEC_PROGRAM(mkdir ARGS -p ${CMAKE_CURRENT_SOURCE_DIR}/build/Wiz OUTPUT_VARIABLE NULL)
EXEC_PROGRAM(mkdir ARGS -p ${CMAKE_CURRENT_SOURCE_DIR}/build/Xcode OUTPUT_VARIABLE NULL)

PROJECT(commandergenius)

# Create the version.h file so the correct version will be shown in the App:
configure_file(version.h.in version.h)

# Generate the readme.txt file
configure_file(readme.txt.in readme.txt)

# main includes
INCLUDE_DIRECTORIES(optional-includes/generated)
INCLUDE_DIRECTORIES(src)

AUX_SOURCE_DIRECTORY(src ROOT_S)
AUX_SOURCE_DIRECTORY(src/common COMMON_S)
AUX_SOURCE_DIRECTORY(src/common/Menu MENU_S)
AUX_SOURCE_DIRECTORY(src/dialog DIALOG_S)
AUX_SOURCE_DIRECTORY(src/engine ENGINE_S)
AUX_SOURCE_DIRECTORY(src/engine/galaxy GALAXY_S)
AUX_SOURCE_DIRECTORY(src/engine/galaxy/ai GALAXY_AI_S)
AUX_SOURCE_DIRECTORY(src/engine/infoscenes INFOSCENES_S)
AUX_SOURCE_DIRECTORY(src/engine/playgame PLAYGAME_S)
AUX_SOURCE_DIRECTORY(src/engine/vorticon VORTICON_S)
AUX_SOURCE_DIRECTORY(src/engine/vorticon/ai AI_S)
AUX_SOURCE_DIRECTORY(src/engine/vorticon/finale FINALE_S)
AUX_SOURCE_DIRECTORY(src/engine/vorticon/playgame VPLAYGAME_S)
AUX_SOURCE_DIRECTORY(src/fileio FILEIO_S)
AUX_SOURCE_DIRECTORY(src/fileio/compression COMPRESSION_S)
AUX_SOURCE_DIRECTORY(src/graphics GRAPHICS_S)
AUX_SOURCE_DIRECTORY(src/graphics/effects EFFECTS_S)
AUX_SOURCE_DIRECTORY(src/scale2x SCALE2X_S)
AUX_SOURCE_DIRECTORY(src/sdl SDL_S)
AUX_SOURCE_DIRECTORY(src/sdl/sound SDLSOUND_S)
AUX_SOURCE_DIRECTORY(src/sdl/music SDLMUSIC_S)
AUX_SOURCE_DIRECTORY(src/sdl/sys SDLSYS_S)
AUX_SOURCE_DIRECTORY(src/sdl/video SDLVIDEO_S)
AUX_SOURCE_DIRECTORY(src/hardware HARDWARE_S)

SET(ALL_SRCS ${COMMON_S} ${MENU_S} ${DIALOG_S} ${ENGINE_S} 
	${AI_S} ${GALAXY_S} ${GALAXY_AI_S} ${INFOSCENES_S} ${PLAYGAME_S} ${VORTICON_S} ${FINALE_S} ${VPLAYGAME_S} ${FILEIO_S} 
	${COMPRESSION_S} ${GRAPHICS_S} ${EFFECTS_S} ${HARDWARE_S} ${SCALE2X_S} ${SDL_S} ${SDLSOUND_S} ${SDLMUSIC_S} ${SDLSYS_S}
	${SDLVIDEO_S} ${ROOT_S})

IF(BUILD_TYPE STREQUAL WIN32)
	SET(ALL_SRCS ${ALL_SRCS} src/CGLogo.o)
ENDIF(BUILD_TYPE STREQUAL WIN32)

IF(UNIX)
# Compilation under Linux
	ADD_DEFINITIONS("-c -fmessage-length=0")

	IF(BUILD_TYPE STREQUAL WIN32)
		set(USRDIR /usr/i586-mingw32msvc)
		set(CMAKE_INCLUDE_PATH ${USRDIR})
		set(CMAKE_C_COMPILER i586-mingw32msvc-gcc)
		set(CMAKE_CXX_COMPILER i586-mingw32msvc-g++)
		set(CMAKE_FIND_ROOT_PATH ${USRDIR})
		set(CMAKE_INSTALL_USRDIR ${USRDIR})
		SET(BUILD_DIR Win32)
		ADD_DEFINITIONS(-DWIN32)
		ADD_DEFINITIONS(-DTARGET_WIN32)
		
	ELSEIF(BUILD_TYPE STREQUAL LINUX32)
		ADD_DEFINITIONS("-DTARGET_LNX")

		IF(HAVE_64_BIT)
			ADD_DEFINITIONS(-D__i386__)
			ADD_DEFINITIONS(-m32)
			set(CMAKE_LIBRARY_PATH ${USRDIR}/lib32)
		ELSE(HAVE_64_BIT)
		ENDIF(HAVE_64_BIT)
		SET(BUILD_DIR Linux32)

	ELSEIF(BUILD_TYPE STREQUAL LINUX64)
		ADD_DEFINITIONS("-DTARGET_LNX")
		SET(BUILD_DIR Linux64)
	ELSE(BUILD_TYPE STREQUAL WIN32)
	ENDIF(BUILD_TYPE STREQUAL WIN32)

	SET(OPTIMIZE_COMPILER_FLAG -O3)
ENDIF(UNIX)


# Extra Flags for the compilation
IF (OGG)
	INCLUDE_DIRECTORIES(${CMAKE_INCLUDE_PATH}/include/vorbis)
	ADD_DEFINITIONS(-DOGG)
ENDIF (OGG)

IF (TREMOR)
	IF(BUILD_TYPE STREQUAL DINGOO)
		INCLUDE_DIRECTORIES(${USRDIR}/include/tremor)
	ELSE (BUILD_TYPE STREQUAL DINGOO)
		INCLUDE_DIRECTORIES(/usr/include/tremor)
	ENDIF (BUILD_TYPE STREQUAL DINGOO)
	ADD_DEFINITIONS(-DTREMOR)
ENDIF (TREMOR)


IF (SDL)
	ADD_DEFINITIONS(-DSDL)

	IF(BUILD_TYPE STREQUAL WIN32)
		INCLUDE_DIRECTORIES(/usr/i586-mingw32msvc/include/SDL)
	ELSE(BUILD_TYPE STREQUAL WIN32)
		INCLUDE_DIRECTORIES(${USRDIR}/include/SDL)
	ENDIF(BUILD_TYPE STREQUAL WIN32)
ENDIF (SDL)

IF (OPENGL)
	ADD_DEFINITIONS(-DGL)
	ADD_DEFINITIONS(-DUSE_OPENGL)
ENDIF (OPENGL)

IF(DEBUG)
	ADD_DEFINITIONS(-DDEBUG)
ENDIF(DEBUG)

# Executable definition
ADD_EXECUTABLE(commandergenius ${ALL_SRCS})

# Linking part under Linux
IF(SDL)	
	IF(BUILD_TYPE STREQUAL WIN32)
		TARGET_LINK_LIBRARIES(commandergenius mingw32)
		TARGET_LINK_LIBRARIES(commandergenius SDLmain)
		TARGET_LINK_LIBRARIES(commandergenius SDL)
		TARGET_LINK_LIBRARIES(commandergenius glu32)
		TARGET_LINK_LIBRARIES(commandergenius opengl32)
	ELSEIF(BUILD_TYPE STREQUAL LINUX32)
		IF(HAVE_64_BIT)
			TARGET_LINK_LIBRARIES(commandergenius SDL-1.2)
		ELSE(HAVE_64_BIT)
			TARGET_LINK_LIBRARIES(commandergenius SDL)
		ENDIF(HAVE_64_BIT)
	ELSE(BUILD_TYPE STREQUAL LINUX32)
		TARGET_LINK_LIBRARIES(commandergenius SDL)
	ENDIF(BUILD_TYPE STREQUAL WIN32)
ENDIF(SDL)

IF(BUILD_TYPE STREQUAL LINUX32)
	IF(HAVE_64_BIT)
		SET_TARGET_PROPERTIES(commandergenius PROPERTIES LINK_FLAGS -L/usr/lib32)
		SET_TARGET_PROPERTIES(commandergenius PROPERTIES LINK_FLAGS -m32)
	ENDIF(HAVE_64_BIT)
ENDIF(BUILD_TYPE STREQUAL LINUX32)

IF(BUILD_TYPE STREQUAL WIN32)
	SET_TARGET_PROPERTIES(commandergenius PROPERTIES LINK_FLAGS -L/usr/i586-mingw32msvc/lib)
	SET_TARGET_PROPERTIES(commandergenius PROPERTIES LINK_FLAGS -mwindows)
ENDIF(BUILD_TYPE STREQUAL WIN32)

IF(OPENGL)
	IF(BUILD_TYPE STREQUAL WIN32)
		TARGET_LINK_LIBRARIES(commandergenius glu32)
		TARGET_LINK_LIBRARIES(commandergenius opengl32)
	ELSE(BUILD_TYPE STREQUAL WIN32)
		TARGET_LINK_LIBRARIES(commandergenius GL)
	ENDIF(BUILD_TYPE STREQUAL WIN32)
ENDIF(OPENGL)

IF(OGG)
	TARGET_LINK_LIBRARIES(commandergenius vorbisfile vorbis)
	IF(BUILD_TYPE STREQUAL WIN32)
		TARGET_LINK_LIBRARIES(commandergenius ogg)
	ENDIF(BUILD_TYPE STREQUAL WIN32)
ENDIF(OGG)

IF(TREMOR)
	TARGET_LINK_LIBRARIES(commandergenius vorbisidec)
ENDIF(TREMOR)

# Set binary(executable) file name. In Windows this filename needs the exe extension
# The Windows Version has an icon in the executable
IF(BUILD_TYPE STREQUAL WIN32)
	SET_TARGET_PROPERTIES(commandergenius PROPERTIES OUTPUT_NAME "build/${BUILD_DIR}/CGenius.exe")
	ADD_CUSTOM_COMMAND(OUTPUT CGLogo.o COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/src/CGLogo.o)
	MESSAGE( "Will build with the CG-Icon for Windows." )
ELSE(BUILD_TYPE STREQUAL WIN32)
	SET_TARGET_PROPERTIES(commandergenius PROPERTIES OUTPUT_NAME "build/${BUILD_DIR}/CGenius")
ENDIF(BUILD_TYPE STREQUAL WIN32)

IF(NOT DEFINED BUILD_TYPE)
	SET(BUILD_TYPE LINUX32)
	MESSAGE( "WARNING: You did not specify the build type with the -DBUILD_TYPE= Parameter. LINUX32 has been choosen" )
	MESSAGE( "Available Builds are: WIN32, LINUX32, LINUX64, GP2X. WIZ, CAANOO, DINGOO, NANONOTE For 64-bit Linux use 'cmake . -DBUILD_TYPE=LINUX64'" )
ENDIF(NOT DEFINED BUILD_TYPE)


MESSAGE( "BUILD_TYPE = ${BUILD_TYPE}" )
MESSAGE( "BUILD_DIR = ${BUILD_DIR}" )
MESSAGE( "DEBUG = ${DEBUG}" )
MESSAGE( "CMAKE_C_COMPILER = ${CMAKE_C_COMPILER}" )
MESSAGE( "CMAKE_C_FLAGS = ${CMAKE_C_FLAGS}" )
MESSAGE( "CMAKE_CXX_COMPILER = ${CMAKE_CXX_COMPILER}" )
MESSAGE( "CMAKE_CXX_FLAGS = ${CMAKE_CXX_FLAGS}" )
MESSAGE( "Compile it with OpenGL : OPENGL = ${OPENGL}" )
MESSAGE( "We use OGG Vorbis : OGG = ${OGG}" )
MESSAGE( "We use Tremor : TREMOR = ${TREMOR}" )
MESSAGE( "You are on 64-bit System : HAVE_64_BIT = ${HAVE_64_BIT}" )
MESSAGE( "USRDIR = ${USRDIR}" )
MESSAGE( "Commander Genius Version : CG_VERSION = ${CG_VERSION}" )

