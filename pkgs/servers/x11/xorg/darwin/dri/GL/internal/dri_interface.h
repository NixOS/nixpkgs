/*
 * Copyright 1998-1999 Precision Insight, Inc., Cedar Park, Texas.
 * Copyright 2007-2008 Red Hat, Inc.
 * (C) Copyright IBM Corporation 2004
 * All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * on the rights to use, copy, modify, merge, publish, distribute, sub
 * license, and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the next
 * paragraph) shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDERS AND/OR THEIR SUPPLIERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
 * USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * \file dri_interface.h
 *
 * This file contains all the types and functions that define the interface
 * between a DRI driver and driver loader.  Currently, the most common driver
 * loader is the XFree86 libGL.so.  However, other loaders do exist, and in
 * the future the server-side libglx.a will also be a loader.
 * 
 * \author Kevin E. Martin <kevin@precisioninsight.com>
 * \author Ian Romanick <idr@us.ibm.com>
 * \author Kristian Høgsberg <krh@redhat.com>
 */

#ifndef DRI_INTERFACE_H
#define DRI_INTERFACE_H

/* For archs with no drm.h */
#if defined(__APPLE__) || defined(__CYGWIN__) || defined(__GNU__)
#ifndef __NOT_HAVE_DRM_H
#define __NOT_HAVE_DRM_H
#endif
#endif

#ifndef __NOT_HAVE_DRM_H
#include <drm.h>
#else
typedef unsigned int drm_context_t;
typedef unsigned int drm_drawable_t;
typedef struct drm_clip_rect drm_clip_rect_t;
#endif

/**
 * \name DRI interface structures
 *
 * The following structures define the interface between the GLX client
 * side library and the DRI (direct rendering infrastructure).
 */
/*@{*/
typedef struct __DRIdisplayRec		__DRIdisplay;
typedef struct __DRIscreenRec		__DRIscreen;
typedef struct __DRIcontextRec		__DRIcontext;
typedef struct __DRIdrawableRec		__DRIdrawable;
typedef struct __DRIconfigRec		__DRIconfig;
typedef struct __DRIframebufferRec	__DRIframebuffer;
typedef struct __DRIversionRec		__DRIversion;

typedef struct __DRIcoreExtensionRec		__DRIcoreExtension;
typedef struct __DRIextensionRec		__DRIextension;
typedef struct __DRIcopySubBufferExtensionRec	__DRIcopySubBufferExtension;
typedef struct __DRIswapControlExtensionRec	__DRIswapControlExtension;
typedef struct __DRIframeTrackingExtensionRec	__DRIframeTrackingExtension;
typedef struct __DRImediaStreamCounterExtensionRec	__DRImediaStreamCounterExtension;
typedef struct __DRItexOffsetExtensionRec	__DRItexOffsetExtension;
typedef struct __DRItexBufferExtensionRec	__DRItexBufferExtension;
typedef struct __DRIlegacyExtensionRec		__DRIlegacyExtension;
typedef struct __DRIswrastExtensionRec		__DRIswrastExtension;
typedef struct __DRIbufferRec			__DRIbuffer;
typedef struct __DRIdri2ExtensionRec		__DRIdri2Extension;
typedef struct __DRIdri2LoaderExtensionRec	__DRIdri2LoaderExtension;
typedef struct __DRI2flushExtensionRec	__DRI2flushExtension;
typedef struct __DRI2throttleExtensionRec	__DRI2throttleExtension;


typedef struct __DRIimageLoaderExtensionRec     __DRIimageLoaderExtension;
typedef struct __DRIimageDriverExtensionRec     __DRIimageDriverExtension;

/*@}*/


/**
 * Extension struct.  Drivers 'inherit' from this struct by embedding
 * it as the first element in the extension struct.
 *
 * We never break API in for a DRI extension.  If we need to change
 * the way things work in a non-backwards compatible manner, we
 * introduce a new extension.  During a transition period, we can
 * leave both the old and the new extension in the driver, which
 * allows us to move to the new interface without having to update the
 * loader(s) in lock step.
 *
 * However, we can add entry points to an extension over time as long
 * as we don't break the old ones.  As we add entry points to an
 * extension, we increase the version number.  The corresponding
 * #define can be used to guard code that accesses the new entry
 * points at compile time and the version field in the extension
 * struct can be used at run-time to determine how to use the
 * extension.
 */
struct __DRIextensionRec {
    const char *name;
    int version;
};

/**
 * The first set of extension are the screen extensions, returned by
 * __DRIcore::getExtensions().  This entry point will return a list of
 * extensions and the loader can use the ones it knows about by
 * casting them to more specific extensions and advertising any GLX
 * extensions the DRI extensions enables.
 */

/**
 * Used by drivers to indicate support for setting the read drawable.
 */
#define __DRI_READ_DRAWABLE "DRI_ReadDrawable"
#define __DRI_READ_DRAWABLE_VERSION 1

/**
 * Used by drivers that implement the GLX_MESA_copy_sub_buffer extension.
 */
#define __DRI_COPY_SUB_BUFFER "DRI_CopySubBuffer"
#define __DRI_COPY_SUB_BUFFER_VERSION 1
struct __DRIcopySubBufferExtensionRec {
    __DRIextension base;
    void (*copySubBuffer)(__DRIdrawable *drawable, int x, int y, int w, int h);
};

/**
 * Used by drivers that implement the GLX_SGI_swap_control or
 * GLX_MESA_swap_control extension.
 */
#define __DRI_SWAP_CONTROL "DRI_SwapControl"
#define __DRI_SWAP_CONTROL_VERSION 1
struct __DRIswapControlExtensionRec {
    __DRIextension base;
    void (*setSwapInterval)(__DRIdrawable *drawable, unsigned int inteval);
    unsigned int (*getSwapInterval)(__DRIdrawable *drawable);
};

/**
 * Used by drivers that implement the GLX_MESA_swap_frame_usage extension.
 */
#define __DRI_FRAME_TRACKING "DRI_FrameTracking"
#define __DRI_FRAME_TRACKING_VERSION 1
struct __DRIframeTrackingExtensionRec {
    __DRIextension base;

    /**
     * Enable or disable frame usage tracking.
     * 
     * \since Internal API version 20030317.
     */
    int (*frameTracking)(__DRIdrawable *drawable, GLboolean enable);

    /**
     * Retrieve frame usage information.
     * 
     * \since Internal API version 20030317.
     */
    int (*queryFrameTracking)(__DRIdrawable *drawable,
			      int64_t * sbc, int64_t * missedFrames,
			      float * lastMissedUsage, float * usage);
};


/**
 * Used by drivers that implement the GLX_SGI_video_sync extension.
 */
#define __DRI_MEDIA_STREAM_COUNTER "DRI_MediaStreamCounter"
#define __DRI_MEDIA_STREAM_COUNTER_VERSION 1
struct __DRImediaStreamCounterExtensionRec {
    __DRIextension base;

    /**
     * Wait for the MSC to equal target_msc, or, if that has already passed,
     * the next time (MSC % divisor) is equal to remainder.  If divisor is
     * zero, the function will return as soon as MSC is greater than or equal
     * to target_msc.
     */
    int (*waitForMSC)(__DRIdrawable *drawable,
		      int64_t target_msc, int64_t divisor, int64_t remainder,
		      int64_t * msc, int64_t * sbc);

    /**
     * Get the number of vertical refreshes since some point in time before
     * this function was first called (i.e., system start up).
     */
    int (*getDrawableMSC)(__DRIscreen *screen, __DRIdrawable *drawable,
			  int64_t *msc);
};


#define __DRI_TEX_OFFSET "DRI_TexOffset"
#define __DRI_TEX_OFFSET_VERSION 1
struct __DRItexOffsetExtensionRec {
    __DRIextension base;

    /**
     * Method to override base texture image with a driver specific 'offset'.
     * The depth passed in allows e.g. to ignore the alpha channel of texture
     * images where the non-alpha components don't occupy a whole texel.
     *
     * For GLX_EXT_texture_from_pixmap with AIGLX.
     */
    void (*setTexOffset)(__DRIcontext *pDRICtx, GLint texname,
			 unsigned long long offset, GLint depth, GLuint pitch);
};


/* Valid values for format in the setTexBuffer2 function below.  These
 * values match the GLX tokens for compatibility reasons, but we
 * define them here since the DRI interface can't depend on GLX. */
#define __DRI_TEXTURE_FORMAT_NONE        0x20D8
#define __DRI_TEXTURE_FORMAT_RGB         0x20D9
#define __DRI_TEXTURE_FORMAT_RGBA        0x20DA

#define __DRI_TEX_BUFFER "DRI_TexBuffer"
#define __DRI_TEX_BUFFER_VERSION 2
struct __DRItexBufferExtensionRec {
    __DRIextension base;

    /**
     * Method to override base texture image with the contents of a
     * __DRIdrawable. 
     *
     * For GLX_EXT_texture_from_pixmap with AIGLX.  Deprecated in favor of
     * setTexBuffer2 in version 2 of this interface
     */
    void (*setTexBuffer)(__DRIcontext *pDRICtx,
			 GLint target,
			 __DRIdrawable *pDraw);

    /**
     * Method to override base texture image with the contents of a
     * __DRIdrawable, including the required texture format attribute.
     *
     * For GLX_EXT_texture_from_pixmap with AIGLX.
     */
    void (*setTexBuffer2)(__DRIcontext *pDRICtx,
			  GLint target,
			  GLint format,
			  __DRIdrawable *pDraw);
    /**
     * Method to release texture buffer in case some special platform
     * need this.
     *
     * For GLX_EXT_texture_from_pixmap with AIGLX.
     */
    void (*releaseTexBuffer)(__DRIcontext *pDRICtx,
			GLint target,
			__DRIdrawable *pDraw);
};

/**
 * Used by drivers that implement DRI2
 */
#define __DRI2_FLUSH "DRI2_Flush"
#define __DRI2_FLUSH_VERSION 4

#define __DRI2_FLUSH_DRAWABLE (1 << 0) /* the drawable should be flushed. */
#define __DRI2_FLUSH_CONTEXT  (1 << 1) /* glFlush should be called */

enum __DRI2throttleReason {
   __DRI2_THROTTLE_SWAPBUFFER,
   __DRI2_THROTTLE_COPYSUBBUFFER,
   __DRI2_THROTTLE_FLUSHFRONT
};

struct __DRI2flushExtensionRec {
    __DRIextension base;
    void (*flush)(__DRIdrawable *drawable);

    /**
     * Ask the driver to call getBuffers/getBuffersWithFormat before
     * it starts rendering again.
     *
     * \param drawable the drawable to invalidate
     *
     * \since 3
     */
    void (*invalidate)(__DRIdrawable *drawable);

    /**
     * This function reduces the number of flushes in the driver by combining
     * several operations into one call.
     *
     * It can:
     * - throttle
     * - flush a drawable
     * - flush a context
     *
     * \param context           the context
     * \param drawable          the drawable to flush
     * \param flags             a combination of _DRI2_FLUSH_xxx flags
     * \param throttle_reason   the reason for throttling, 0 = no throttling
     *
     * \since 4
     */
    void (*flush_with_flags)(__DRIcontext *ctx,
                             __DRIdrawable *drawable,
                             unsigned flags,
                             enum __DRI2throttleReason throttle_reason);
};


/**
 * Extension that the driver uses to request
 * throttle callbacks.
 */

#define __DRI2_THROTTLE "DRI2_Throttle"
#define __DRI2_THROTTLE_VERSION 1

struct __DRI2throttleExtensionRec {
   __DRIextension base;
   void (*throttle)(__DRIcontext *ctx,
		    __DRIdrawable *drawable,
		    enum __DRI2throttleReason reason);
};

/*@}*/

/**
 * The following extensions describe loader features that the DRI
 * driver can make use of.  Some of these are mandatory, such as the
 * getDrawableInfo extension for DRI and the DRI Loader extensions for
 * DRI2, while others are optional, and if present allow the driver to
 * expose certain features.  The loader pass in a NULL terminated
 * array of these extensions to the driver in the createNewScreen
 * constructor.
 */

typedef struct __DRIgetDrawableInfoExtensionRec __DRIgetDrawableInfoExtension;
typedef struct __DRIsystemTimeExtensionRec __DRIsystemTimeExtension;
typedef struct __DRIdamageExtensionRec __DRIdamageExtension;
typedef struct __DRIloaderExtensionRec __DRIloaderExtension;
typedef struct __DRIswrastLoaderExtensionRec __DRIswrastLoaderExtension;


/**
 * Callback to getDrawableInfo protocol
 */
#define __DRI_GET_DRAWABLE_INFO "DRI_GetDrawableInfo"
#define __DRI_GET_DRAWABLE_INFO_VERSION 1
struct __DRIgetDrawableInfoExtensionRec {
    __DRIextension base;

    /**
     * This function is used to get information about the position, size, and
     * clip rects of a drawable.
     */
    GLboolean (* getDrawableInfo) ( __DRIdrawable *drawable,
	unsigned int * index, unsigned int * stamp,
        int * x, int * y, int * width, int * height,
        int * numClipRects, drm_clip_rect_t ** pClipRects,
        int * backX, int * backY,
	int * numBackClipRects, drm_clip_rect_t ** pBackClipRects,
	void *loaderPrivate);
};

/**
 * Callback to get system time for media stream counter extensions.
 */
#define __DRI_SYSTEM_TIME "DRI_SystemTime"
#define __DRI_SYSTEM_TIME_VERSION 1
struct __DRIsystemTimeExtensionRec {
    __DRIextension base;

    /**
     * Get the 64-bit unadjusted system time (UST).
     */
    int (*getUST)(int64_t * ust);

    /**
     * Get the media stream counter (MSC) rate.
     * 
     * Matching the definition in GLX_OML_sync_control, this function returns
     * the rate of the "media stream counter".  In practical terms, this is
     * the frame refresh rate of the display.
     */
    GLboolean (*getMSCRate)(__DRIdrawable *draw,
			    int32_t * numerator, int32_t * denominator,
			    void *loaderPrivate);
};

/**
 * Damage reporting
 */
#define __DRI_DAMAGE "DRI_Damage"
#define __DRI_DAMAGE_VERSION 1
struct __DRIdamageExtensionRec {
    __DRIextension base;

    /**
     * Reports areas of the given drawable which have been modified by the
     * driver.
     *
     * \param drawable which the drawing was done to.
     * \param rects rectangles affected, with the drawable origin as the
     *	      origin.
     * \param x X offset of the drawable within the screen (used in the
     *	      front_buffer case)
     * \param y Y offset of the drawable within the screen.
     * \param front_buffer boolean flag for whether the drawing to the
     * 	      drawable was actually done directly to the front buffer (instead
     *	      of backing storage, for example)
     * \param loaderPrivate the data passed in at createNewDrawable time
     */
    void (*reportDamage)(__DRIdrawable *draw,
			 int x, int y,
			 drm_clip_rect_t *rects, int num_rects,
			 GLboolean front_buffer,
			 void *loaderPrivate);
};

#define __DRI_SWRAST_IMAGE_OP_DRAW	1
#define __DRI_SWRAST_IMAGE_OP_CLEAR	2
#define __DRI_SWRAST_IMAGE_OP_SWAP	3

/**
 * SWRast Loader extension.
 */
#define __DRI_SWRAST_LOADER "DRI_SWRastLoader"
#define __DRI_SWRAST_LOADER_VERSION 1
struct __DRIswrastLoaderExtensionRec {
    __DRIextension base;

    /*
     * Drawable position and size
     */
    void (*getDrawableInfo)(__DRIdrawable *drawable,
			    int *x, int *y, int *width, int *height,
			    void *loaderPrivate);

    /**
     * Put image to drawable
     */
    void (*putImage)(__DRIdrawable *drawable, int op,
		     int x, int y, int width, int height,
		     char *data, void *loaderPrivate);

    /**
     * Get image from readable
     */
    void (*getImage)(__DRIdrawable *readable,
		     int x, int y, int width, int height,
		     char *data, void *loaderPrivate);
};

/**
 * Invalidate loader extension.  The presence of this extension
 * indicates to the DRI driver that the loader will call invalidate in
 * the __DRI2_FLUSH extension, whenever the needs to query for new
 * buffers.  This means that the DRI driver can drop the polling in
 * glViewport().
 *
 * The extension doesn't provide any functionality, it's only use to
 * indicate to the driver that it can use the new semantics.  A DRI
 * driver can use this to switch between the different semantics or
 * just refuse to initialize if this extension isn't present.
 */
#define __DRI_USE_INVALIDATE "DRI_UseInvalidate"
#define __DRI_USE_INVALIDATE_VERSION 1

typedef struct __DRIuseInvalidateExtensionRec __DRIuseInvalidateExtension;
struct __DRIuseInvalidateExtensionRec {
   __DRIextension base;
};

/**
 * The remaining extensions describe driver extensions, immediately
 * available interfaces provided by the driver.  To start using the
 * driver, dlsym() for the __DRI_DRIVER_EXTENSIONS symbol and look for
 * the extension you need in the array.
 */
#define __DRI_DRIVER_EXTENSIONS "__driDriverExtensions"

/**
 * This symbol replaces the __DRI_DRIVER_EXTENSIONS symbol, and will be
 * suffixed by "_drivername", allowing multiple drivers to be built into one
 * library, and also giving the driver the chance to return a variable driver
 * extensions struct depending on the driver name being loaded or any other
 * system state.
 *
 * The function prototype is:
 *
 * const __DRIextension **__driDriverGetExtensions_drivername(void);
 */
#define __DRI_DRIVER_GET_EXTENSIONS "__driDriverGetExtensions"

/**
 * Tokens for __DRIconfig attribs.  A number of attributes defined by
 * GLX or EGL standards are not in the table, as they must be provided
 * by the loader.  For example, FBConfig ID or visual ID, drawable type.
 */

#define __DRI_ATTRIB_BUFFER_SIZE		 1
#define __DRI_ATTRIB_LEVEL			 2
#define __DRI_ATTRIB_RED_SIZE			 3
#define __DRI_ATTRIB_GREEN_SIZE			 4
#define __DRI_ATTRIB_BLUE_SIZE			 5
#define __DRI_ATTRIB_LUMINANCE_SIZE		 6
#define __DRI_ATTRIB_ALPHA_SIZE			 7
#define __DRI_ATTRIB_ALPHA_MASK_SIZE		 8
#define __DRI_ATTRIB_DEPTH_SIZE			 9
#define __DRI_ATTRIB_STENCIL_SIZE		10
#define __DRI_ATTRIB_ACCUM_RED_SIZE		11
#define __DRI_ATTRIB_ACCUM_GREEN_SIZE		12
#define __DRI_ATTRIB_ACCUM_BLUE_SIZE		13
#define __DRI_ATTRIB_ACCUM_ALPHA_SIZE		14
#define __DRI_ATTRIB_SAMPLE_BUFFERS		15
#define __DRI_ATTRIB_SAMPLES			16
#define __DRI_ATTRIB_RENDER_TYPE		17
#define __DRI_ATTRIB_CONFIG_CAVEAT		18
#define __DRI_ATTRIB_CONFORMANT			19
#define __DRI_ATTRIB_DOUBLE_BUFFER		20
#define __DRI_ATTRIB_STEREO			21
#define __DRI_ATTRIB_AUX_BUFFERS		22
#define __DRI_ATTRIB_TRANSPARENT_TYPE		23
#define __DRI_ATTRIB_TRANSPARENT_INDEX_VALUE	24
#define __DRI_ATTRIB_TRANSPARENT_RED_VALUE	25
#define __DRI_ATTRIB_TRANSPARENT_GREEN_VALUE	26
#define __DRI_ATTRIB_TRANSPARENT_BLUE_VALUE	27
#define __DRI_ATTRIB_TRANSPARENT_ALPHA_VALUE	28
#define __DRI_ATTRIB_FLOAT_MODE			29
#define __DRI_ATTRIB_RED_MASK			30
#define __DRI_ATTRIB_GREEN_MASK			31
#define __DRI_ATTRIB_BLUE_MASK			32
#define __DRI_ATTRIB_ALPHA_MASK			33
#define __DRI_ATTRIB_MAX_PBUFFER_WIDTH		34
#define __DRI_ATTRIB_MAX_PBUFFER_HEIGHT		35
#define __DRI_ATTRIB_MAX_PBUFFER_PIXELS		36
#define __DRI_ATTRIB_OPTIMAL_PBUFFER_WIDTH	37
#define __DRI_ATTRIB_OPTIMAL_PBUFFER_HEIGHT	38
#define __DRI_ATTRIB_VISUAL_SELECT_GROUP	39
#define __DRI_ATTRIB_SWAP_METHOD		40
#define __DRI_ATTRIB_MAX_SWAP_INTERVAL		41
#define __DRI_ATTRIB_MIN_SWAP_INTERVAL		42
#define __DRI_ATTRIB_BIND_TO_TEXTURE_RGB	43
#define __DRI_ATTRIB_BIND_TO_TEXTURE_RGBA	44
#define __DRI_ATTRIB_BIND_TO_MIPMAP_TEXTURE	45
#define __DRI_ATTRIB_BIND_TO_TEXTURE_TARGETS	46
#define __DRI_ATTRIB_YINVERTED			47
#define __DRI_ATTRIB_FRAMEBUFFER_SRGB_CAPABLE	48

/* __DRI_ATTRIB_RENDER_TYPE */
#define __DRI_ATTRIB_RGBA_BIT			0x01	
#define __DRI_ATTRIB_COLOR_INDEX_BIT		0x02
#define __DRI_ATTRIB_LUMINANCE_BIT		0x04
#define __DRI_ATTRIB_FLOAT_BIT			0x08
#define __DRI_ATTRIB_UNSIGNED_FLOAT_BIT		0x10

/* __DRI_ATTRIB_CONFIG_CAVEAT */
#define __DRI_ATTRIB_SLOW_BIT			0x01
#define __DRI_ATTRIB_NON_CONFORMANT_CONFIG	0x02

/* __DRI_ATTRIB_TRANSPARENT_TYPE */
#define __DRI_ATTRIB_TRANSPARENT_RGB		0x00
#define __DRI_ATTRIB_TRANSPARENT_INDEX		0x01

/* __DRI_ATTRIB_BIND_TO_TEXTURE_TARGETS	 */
#define __DRI_ATTRIB_TEXTURE_1D_BIT		0x01
#define __DRI_ATTRIB_TEXTURE_2D_BIT		0x02
#define __DRI_ATTRIB_TEXTURE_RECTANGLE_BIT	0x04

/**
 * This extension defines the core DRI functionality.
 */
#define __DRI_CORE "DRI_Core"
#define __DRI_CORE_VERSION 1

struct __DRIcoreExtensionRec {
    __DRIextension base;

    __DRIscreen *(*createNewScreen)(int screen, int fd,
				    unsigned int sarea_handle,
				    const __DRIextension **extensions,
				    const __DRIconfig ***driverConfigs,
				    void *loaderPrivate);

    void (*destroyScreen)(__DRIscreen *screen);

    const __DRIextension **(*getExtensions)(__DRIscreen *screen);

    int (*getConfigAttrib)(const __DRIconfig *config,
			   unsigned int attrib,
			   unsigned int *value);

    int (*indexConfigAttrib)(const __DRIconfig *config, int index,
			     unsigned int *attrib, unsigned int *value);

    __DRIdrawable *(*createNewDrawable)(__DRIscreen *screen,
					const __DRIconfig *config,
					unsigned int drawable_id,
					unsigned int head,
					void *loaderPrivate);

    void (*destroyDrawable)(__DRIdrawable *drawable);

    void (*swapBuffers)(__DRIdrawable *drawable);

    __DRIcontext *(*createNewContext)(__DRIscreen *screen,
				      const __DRIconfig *config,
				      __DRIcontext *shared,
				      void *loaderPrivate);

    int (*copyContext)(__DRIcontext *dest,
		       __DRIcontext *src,
		       unsigned long mask);

    void (*destroyContext)(__DRIcontext *context);

    int (*bindContext)(__DRIcontext *ctx,
		       __DRIdrawable *pdraw,
		       __DRIdrawable *pread);

    int (*unbindContext)(__DRIcontext *ctx);
};

/**
 * Stored version of some component (i.e., server-side DRI module, kernel-side
 * DRM, etc.).
 * 
 * \todo
 * There are several data structures that explicitly store a major version,
 * minor version, and patch level.  These structures should be modified to
 * have a \c __DRIversionRec instead.
 */
struct __DRIversionRec {
    int    major;        /**< Major version number. */
    int    minor;        /**< Minor version number. */
    int    patch;        /**< Patch-level. */
};

/**
 * Framebuffer information record.  Used by libGL to communicate information
 * about the framebuffer to the driver's \c __driCreateNewScreen function.
 * 
 * In XFree86, most of this information is derrived from data returned by
 * calling \c XF86DRIGetDeviceInfo.
 *
 * \sa XF86DRIGetDeviceInfo __DRIdisplayRec::createNewScreen
 *     __driUtilCreateNewScreen CallCreateNewScreen
 *
 * \bug This structure could be better named.
 */
struct __DRIframebufferRec {
    unsigned char *base;    /**< Framebuffer base address in the CPU's
			     * address space.  This value is calculated by
			     * calling \c drmMap on the framebuffer handle
			     * returned by \c XF86DRIGetDeviceInfo (or a
			     * similar function).
			     */
    int size;               /**< Framebuffer size, in bytes. */
    int stride;             /**< Number of bytes from one line to the next. */
    int width;              /**< Pixel width of the framebuffer. */
    int height;             /**< Pixel height of the framebuffer. */
    int dev_priv_size;      /**< Size of the driver's dev-priv structure. */
    void *dev_priv;         /**< Pointer to the driver's dev-priv structure. */
};


/**
 * This extension provides alternative screen, drawable and context
 * constructors for legacy DRI functionality.  This is used in
 * conjunction with the core extension.
 */
#define __DRI_LEGACY "DRI_Legacy"
#define __DRI_LEGACY_VERSION 1

struct __DRIlegacyExtensionRec {
    __DRIextension base;

    __DRIscreen *(*createNewScreen)(int screen,
				    const __DRIversion *ddx_version,
				    const __DRIversion *dri_version,
				    const __DRIversion *drm_version,
				    const __DRIframebuffer *frame_buffer,
				    void *pSAREA, int fd, 
				    const __DRIextension **extensions,
				    const __DRIconfig ***driver_configs,
				    void *loaderPrivate);

    __DRIdrawable *(*createNewDrawable)(__DRIscreen *screen,
					const __DRIconfig *config,
					drm_drawable_t hwDrawable,
					int renderType, const int *attrs,
					void *loaderPrivate);

    __DRIcontext *(*createNewContext)(__DRIscreen *screen,
				      const __DRIconfig *config,
				      int render_type,
				      __DRIcontext *shared,
				      drm_context_t hwContext,
				      void *loaderPrivate);
};

/**
 * This extension provides alternative screen, drawable and context
 * constructors for swrast DRI functionality.  This is used in
 * conjunction with the core extension.
 */
#define __DRI_SWRAST "DRI_SWRast"
#define __DRI_SWRAST_VERSION 4

struct __DRIswrastExtensionRec {
    __DRIextension base;

    __DRIscreen *(*createNewScreen)(int screen,
				    const __DRIextension **extensions,
				    const __DRIconfig ***driver_configs,
				    void *loaderPrivate);

    __DRIdrawable *(*createNewDrawable)(__DRIscreen *screen,
					const __DRIconfig *config,
					void *loaderPrivate);

   /* Since version 2 */
   __DRIcontext *(*createNewContextForAPI)(__DRIscreen *screen,
                                           int api,
                                           const __DRIconfig *config,
                                           __DRIcontext *shared,
                                           void *data);

   /**
    * Create a context for a particular API with a set of attributes
    *
    * \since version 3
    *
    * \sa __DRIdri2ExtensionRec::createContextAttribs
    */
   __DRIcontext *(*createContextAttribs)(__DRIscreen *screen,
					 int api,
					 const __DRIconfig *config,
					 __DRIcontext *shared,
					 unsigned num_attribs,
					 const uint32_t *attribs,
					 unsigned *error,
					 void *loaderPrivate);

   /**
    * createNewScreen() with the driver extensions passed in.
    *
    * \since version 4
    */
   __DRIscreen *(*createNewScreen2)(int screen,
                                    const __DRIextension **loader_extensions,
                                    const __DRIextension **driver_extensions,
                                    const __DRIconfig ***driver_configs,
                                    void *loaderPrivate);

};

/** Common DRI function definitions, shared among DRI2 and Image extensions
 */

typedef __DRIscreen *
(*__DRIcreateNewScreen2Func)(int screen, int fd,
                             const __DRIextension **extensions,
                             const __DRIextension **driver_extensions,
                             const __DRIconfig ***driver_configs,
                             void *loaderPrivate);

typedef __DRIdrawable *
(*__DRIcreateNewDrawableFunc)(__DRIscreen *screen,
                              const __DRIconfig *config,
                              void *loaderPrivate);

typedef __DRIcontext *
(*__DRIcreateContextAttribsFunc)(__DRIscreen *screen,
                                 int api,
                                 const __DRIconfig *config,
                                 __DRIcontext *shared,
                                 unsigned num_attribs,
                                 const uint32_t *attribs,
                                 unsigned *error,
                                 void *loaderPrivate);

typedef unsigned int
(*__DRIgetAPIMaskFunc)(__DRIscreen *screen);

/**
 * DRI2 Loader extension.
 */
#define __DRI_BUFFER_FRONT_LEFT		0
#define __DRI_BUFFER_BACK_LEFT		1
#define __DRI_BUFFER_FRONT_RIGHT	2
#define __DRI_BUFFER_BACK_RIGHT		3
#define __DRI_BUFFER_DEPTH		4
#define __DRI_BUFFER_STENCIL		5
#define __DRI_BUFFER_ACCUM		6
#define __DRI_BUFFER_FAKE_FRONT_LEFT	7
#define __DRI_BUFFER_FAKE_FRONT_RIGHT	8
#define __DRI_BUFFER_DEPTH_STENCIL	9  /**< Only available with DRI2 1.1 */
#define __DRI_BUFFER_HIZ		10

/* Inofficial and for internal use. Increase when adding a new buffer token. */
#define __DRI_BUFFER_COUNT		11

struct __DRIbufferRec {
    unsigned int attachment;
    unsigned int name;
    unsigned int pitch;
    unsigned int cpp;
    unsigned int flags;
};

#define __DRI_DRI2_LOADER "DRI_DRI2Loader"
#define __DRI_DRI2_LOADER_VERSION 3
struct __DRIdri2LoaderExtensionRec {
    __DRIextension base;

    __DRIbuffer *(*getBuffers)(__DRIdrawable *driDrawable,
			       int *width, int *height,
			       unsigned int *attachments, int count,
			       int *out_count, void *loaderPrivate);

    /**
     * Flush pending front-buffer rendering
     *
     * Any rendering that has been performed to the
     * \c __DRI_BUFFER_FAKE_FRONT_LEFT will be flushed to the
     * \c __DRI_BUFFER_FRONT_LEFT.
     *
     * \param driDrawable    Drawable whose front-buffer is to be flushed
     * \param loaderPrivate  Loader's private data that was previously passed
     *                       into __DRIdri2ExtensionRec::createNewDrawable
     */
    void (*flushFrontBuffer)(__DRIdrawable *driDrawable, void *loaderPrivate);


    /**
     * Get list of buffers from the server
     *
     * Gets a list of buffer for the specified set of attachments.  Unlike
     * \c ::getBuffers, this function takes a list of attachments paired with
     * opaque \c unsigned \c int value describing the format of the buffer.
     * It is the responsibility of the caller to know what the service that
     * allocates the buffers will expect to receive for the format.
     *
     * \param driDrawable    Drawable whose buffers are being queried.
     * \param width          Output where the width of the buffers is stored.
     * \param height         Output where the height of the buffers is stored.
     * \param attachments    List of pairs of attachment ID and opaque format
     *                       requested for the drawable.
     * \param count          Number of attachment / format pairs stored in
     *                       \c attachments.
     * \param loaderPrivate  Loader's private data that was previously passed
     *                       into __DRIdri2ExtensionRec::createNewDrawable.
     */
    __DRIbuffer *(*getBuffersWithFormat)(__DRIdrawable *driDrawable,
					 int *width, int *height,
					 unsigned int *attachments, int count,
					 int *out_count, void *loaderPrivate);
};

/**
 * This extension provides alternative screen, drawable and context
 * constructors for DRI2.
 */
#define __DRI_DRI2 "DRI_DRI2"
#define __DRI_DRI2_VERSION 4

#define __DRI_API_OPENGL	0	/**< OpenGL compatibility profile */
#define __DRI_API_GLES		1	/**< OpenGL ES 1.x */
#define __DRI_API_GLES2		2	/**< OpenGL ES 2.x */
#define __DRI_API_OPENGL_CORE	3	/**< OpenGL 3.2+ core profile */
#define __DRI_API_GLES3		4	/**< OpenGL ES 3.x */

#define __DRI_CTX_ATTRIB_MAJOR_VERSION		0
#define __DRI_CTX_ATTRIB_MINOR_VERSION		1
#define __DRI_CTX_ATTRIB_FLAGS			2

/**
 * \requires __DRI2_ROBUSTNESS.
 */
#define __DRI_CTX_ATTRIB_RESET_STRATEGY		3

#define __DRI_CTX_FLAG_DEBUG			0x00000001
#define __DRI_CTX_FLAG_FORWARD_COMPATIBLE	0x00000002

/**
 * \requires __DRI2_ROBUSTNESS.
 */
#define __DRI_CTX_FLAG_ROBUST_BUFFER_ACCESS	0x00000004

/**
 * \name Context reset strategies.
 */
/*@{*/
#define __DRI_CTX_RESET_NO_NOTIFICATION		0
#define __DRI_CTX_RESET_LOSE_CONTEXT		1
/*@}*/

/**
 * \name Reasons that __DRIdri2Extension::createContextAttribs might fail
 */
/*@{*/
/** Success! */
#define __DRI_CTX_ERROR_SUCCESS			0

/** Memory allocation failure */
#define __DRI_CTX_ERROR_NO_MEMORY		1

/** Client requested an API (e.g., OpenGL ES 2.0) that the driver can't do. */
#define __DRI_CTX_ERROR_BAD_API			2

/** Client requested an API version that the driver can't do. */
#define __DRI_CTX_ERROR_BAD_VERSION		3

/** Client requested a flag or combination of flags the driver can't do. */
#define __DRI_CTX_ERROR_BAD_FLAG		4

/** Client requested an attribute the driver doesn't understand. */
#define __DRI_CTX_ERROR_UNKNOWN_ATTRIBUTE	5

/** Client requested a flag the driver doesn't understand. */
#define __DRI_CTX_ERROR_UNKNOWN_FLAG		6
/*@}*/

struct __DRIdri2ExtensionRec {
    __DRIextension base;

    __DRIscreen *(*createNewScreen)(int screen, int fd,
				    const __DRIextension **extensions,
				    const __DRIconfig ***driver_configs,
				    void *loaderPrivate);

   __DRIcreateNewDrawableFunc   createNewDrawable;
   __DRIcontext *(*createNewContext)(__DRIscreen *screen,
                                     const __DRIconfig *config,
                                     __DRIcontext *shared,
                                     void *loaderPrivate);

   /* Since version 2 */
   __DRIgetAPIMaskFunc          getAPIMask;

   __DRIcontext *(*createNewContextForAPI)(__DRIscreen *screen,
					   int api,
					   const __DRIconfig *config,
					   __DRIcontext *shared,
					   void *data);

   __DRIbuffer *(*allocateBuffer)(__DRIscreen *screen,
				  unsigned int attachment,
				  unsigned int format,
				  int width,
				  int height);
   void (*releaseBuffer)(__DRIscreen *screen,
			 __DRIbuffer *buffer);

   /**
    * Create a context for a particular API with a set of attributes
    *
    * \since version 3
    *
    * \sa __DRIswrastExtensionRec::createContextAttribs
    */
   __DRIcreateContextAttribsFunc        createContextAttribs;

   /**
    * createNewScreen with the driver's extension list passed in.
    *
    * \since version 4
    */
   __DRIcreateNewScreen2Func            createNewScreen2;
};


/**
 * This extension provides functionality to enable various EGLImage
 * extensions.
 */
#define __DRI_IMAGE "DRI_IMAGE"
#define __DRI_IMAGE_VERSION 8

/**
 * These formats correspond to the similarly named MESA_FORMAT_*
 * tokens, except in the native endian of the CPU.  For example, on
 * little endian __DRI_IMAGE_FORMAT_XRGB8888 corresponds to
 * MESA_FORMAT_XRGB8888, but MESA_FORMAT_XRGB8888_REV on big endian.
 *
 * __DRI_IMAGE_FORMAT_NONE is for images that aren't directly usable
 * by the driver (YUV planar formats) but serve as a base image for
 * creating sub-images for the different planes within the image.
 *
 * R8, GR88 and NONE should not be used with createImageFormName or
 * createImage, and are returned by query from sub images created with
 * createImageFromNames (NONE, see above) and fromPlane (R8 & GR88).
 */
#define __DRI_IMAGE_FORMAT_RGB565       0x1001
#define __DRI_IMAGE_FORMAT_XRGB8888     0x1002
#define __DRI_IMAGE_FORMAT_ARGB8888     0x1003
#define __DRI_IMAGE_FORMAT_ABGR8888     0x1004
#define __DRI_IMAGE_FORMAT_XBGR8888     0x1005
#define __DRI_IMAGE_FORMAT_R8           0x1006 /* Since version 5 */
#define __DRI_IMAGE_FORMAT_GR88         0x1007
#define __DRI_IMAGE_FORMAT_NONE         0x1008
#define __DRI_IMAGE_FORMAT_XRGB2101010  0x1009
#define __DRI_IMAGE_FORMAT_ARGB2101010  0x100a
#define __DRI_IMAGE_FORMAT_SARGB8       0x100b

#define __DRI_IMAGE_USE_SHARE		0x0001
#define __DRI_IMAGE_USE_SCANOUT		0x0002
#define __DRI_IMAGE_USE_CURSOR		0x0004 /* Depricated */
#define __DRI_IMAGE_USE_LINEAR		0x0008


/**
 * Four CC formats that matches with WL_DRM_FORMAT_* from wayland_drm.h
 * and GBM_FORMAT_* from gbm.h, used with createImageFromNames.
 *
 * \since 5
 */

#define __DRI_IMAGE_FOURCC_RGB565	0x36314752
#define __DRI_IMAGE_FOURCC_ARGB8888	0x34325241
#define __DRI_IMAGE_FOURCC_XRGB8888	0x34325258
#define __DRI_IMAGE_FOURCC_ABGR8888	0x34324241
#define __DRI_IMAGE_FOURCC_XBGR8888	0x34324258
#define __DRI_IMAGE_FOURCC_YUV410	0x39565559
#define __DRI_IMAGE_FOURCC_YUV411	0x31315559
#define __DRI_IMAGE_FOURCC_YUV420	0x32315559
#define __DRI_IMAGE_FOURCC_YUV422	0x36315559
#define __DRI_IMAGE_FOURCC_YUV444	0x34325559
#define __DRI_IMAGE_FOURCC_NV12		0x3231564e
#define __DRI_IMAGE_FOURCC_NV16		0x3631564e
#define __DRI_IMAGE_FOURCC_YUYV		0x56595559


/**
 * Queryable on images created by createImageFromNames.
 *
 * RGB and RGBA are may be usable directly as images but its still
 * recommended to call fromPlanar with plane == 0.
 *
 * Y_U_V, Y_UV and Y_XUXV all requires call to fromPlanar to create
 * usable sub-images, sampling from images return raw YUV data and
 * color conversion needs to be done in the shader.
 *
 * \since 5
 */

#define __DRI_IMAGE_COMPONENTS_RGB	0x3001
#define __DRI_IMAGE_COMPONENTS_RGBA	0x3002
#define __DRI_IMAGE_COMPONENTS_Y_U_V	0x3003
#define __DRI_IMAGE_COMPONENTS_Y_UV	0x3004
#define __DRI_IMAGE_COMPONENTS_Y_XUXV	0x3005


/**
 * queryImage attributes
 */

#define __DRI_IMAGE_ATTRIB_STRIDE	0x2000
#define __DRI_IMAGE_ATTRIB_HANDLE	0x2001
#define __DRI_IMAGE_ATTRIB_NAME		0x2002
#define __DRI_IMAGE_ATTRIB_FORMAT	0x2003 /* available in versions 3+ */
#define __DRI_IMAGE_ATTRIB_WIDTH	0x2004 /* available in versions 4+ */
#define __DRI_IMAGE_ATTRIB_HEIGHT	0x2005
#define __DRI_IMAGE_ATTRIB_COMPONENTS	0x2006 /* available in versions 5+ */
#define __DRI_IMAGE_ATTRIB_FD           0x2007 /* available in versions
                                                * 7+. Each query will return a
                                                * new fd. */

enum __DRIYUVColorSpace {
   __DRI_YUV_COLOR_SPACE_UNDEFINED = 0,
   __DRI_YUV_COLOR_SPACE_ITU_REC601 = 0x327F,
   __DRI_YUV_COLOR_SPACE_ITU_REC709 = 0x3280,
   __DRI_YUV_COLOR_SPACE_ITU_REC2020 = 0x3281
};

enum __DRISampleRange {
   __DRI_YUV_RANGE_UNDEFINED = 0,
   __DRI_YUV_FULL_RANGE = 0x3282,
   __DRI_YUV_NARROW_RANGE = 0x3283
};

enum __DRIChromaSiting {
   __DRI_YUV_CHROMA_SITING_UNDEFINED = 0,
   __DRI_YUV_CHROMA_SITING_0 = 0x3284,
   __DRI_YUV_CHROMA_SITING_0_5 = 0x3285
};

/**
 * \name Reasons that __DRIimageExtensionRec::createImageFromTexture might fail
 */
/*@{*/
/** Success! */
#define __DRI_IMAGE_ERROR_SUCCESS       0

/** Memory allocation failure */
#define __DRI_IMAGE_ERROR_BAD_ALLOC     1

/** Client requested an invalid attribute for a texture object  */
#define __DRI_IMAGE_ERROR_BAD_MATCH     2

/** Client requested an invalid texture object */
#define __DRI_IMAGE_ERROR_BAD_PARAMETER 3
/*@}*/

typedef struct __DRIimageRec          __DRIimage;
typedef struct __DRIimageExtensionRec __DRIimageExtension;
struct __DRIimageExtensionRec {
    __DRIextension base;

    __DRIimage *(*createImageFromName)(__DRIscreen *screen,
				       int width, int height, int format,
				       int name, int pitch,
				       void *loaderPrivate);

    __DRIimage *(*createImageFromRenderbuffer)(__DRIcontext *context,
					       int renderbuffer,
					       void *loaderPrivate);

    void (*destroyImage)(__DRIimage *image);

    __DRIimage *(*createImage)(__DRIscreen *screen,
			       int width, int height, int format,
			       unsigned int use,
			       void *loaderPrivate);

   GLboolean (*queryImage)(__DRIimage *image, int attrib, int *value);

   /**
    * The new __DRIimage will share the content with the old one, see dup(2).
    */
   __DRIimage *(*dupImage)(__DRIimage *image, void *loaderPrivate);

   /**
    * Validate that a __DRIimage can be used a certain way.
    *
    * \since 2
    */
   GLboolean (*validateUsage)(__DRIimage *image, unsigned int use);

   /**
    * Unlike createImageFromName __DRI_IMAGE_FORMAT is not but instead
    * __DRI_IMAGE_FOURCC and strides are in bytes not pixels. Stride is
    * also per block and not per pixel (for non-RGB, see gallium blocks).
    *
    * \since 5
    */
   __DRIimage *(*createImageFromNames)(__DRIscreen *screen,
                                       int width, int height, int fourcc,
                                       int *names, int num_names,
                                       int *strides, int *offsets,
                                       void *loaderPrivate);

   /**
    * Create an image out of a sub-region of a parent image.  This
    * entry point lets us create individual __DRIimages for different
    * planes in a planar buffer (typically yuv), for example.  While a
    * sub-image shares the underlying buffer object with the parent
    * image and other sibling sub-images, the life times of parent and
    * sub-images are not dependent.  Destroying the parent or a
    * sub-image doesn't affect other images.  The underlying buffer
    * object is free when no __DRIimage remains that references it.
    *
    * Sub-images may overlap, but rendering to overlapping sub-images
    * is undefined.
    *
    * \since 5
    */
    __DRIimage *(*fromPlanar)(__DRIimage *image, int plane,
                              void *loaderPrivate);

    /**
     * Create image from texture.
     *
     * \since 6
     */
   __DRIimage *(*createImageFromTexture)(__DRIcontext *context,
                                         int target,
                                         unsigned texture,
                                         int depth,
                                         int level,
                                         unsigned *error,
                                         void *loaderPrivate);
   /**
    * Like createImageFromNames, but takes a prime fd instead.
    *
    * \since 7
    */
   __DRIimage *(*createImageFromFds)(__DRIscreen *screen,
                                     int width, int height, int fourcc,
                                     int *fds, int num_fds,
                                     int *strides, int *offsets,
                                     void *loaderPrivate);

   /**
    * Like createImageFromFds, but takes additional attributes.
    *
    * For EGL_EXT_image_dma_buf_import.
    *
    * \since 8
    */
   __DRIimage *(*createImageFromDmaBufs)(__DRIscreen *screen,
                                         int width, int height, int fourcc,
                                         int *fds, int num_fds,
                                         int *strides, int *offsets,
                                         enum __DRIYUVColorSpace color_space,
                                         enum __DRISampleRange sample_range,
                                         enum __DRIChromaSiting horiz_siting,
                                         enum __DRIChromaSiting vert_siting,
                                         unsigned *error,
                                         void *loaderPrivate);
};


/**
 * This extension must be implemented by the loader and passed to the
 * driver at screen creation time.  The EGLImage entry points in the
 * various client APIs take opaque EGLImage handles and use this
 * extension to map them to a __DRIimage.  At version 1, this
 * extensions allows mapping EGLImage pointers to __DRIimage pointers,
 * but future versions could support other EGLImage-like, opaque types
 * with new lookup functions.
 */
#define __DRI_IMAGE_LOOKUP "DRI_IMAGE_LOOKUP"
#define __DRI_IMAGE_LOOKUP_VERSION 1

typedef struct __DRIimageLookupExtensionRec __DRIimageLookupExtension;
struct __DRIimageLookupExtensionRec {
    __DRIextension base;

    __DRIimage *(*lookupEGLImage)(__DRIscreen *screen, void *image,
				  void *loaderPrivate);
};

/**
 * This extension allows for common DRI2 options
 */
#define __DRI2_CONFIG_QUERY "DRI_CONFIG_QUERY"
#define __DRI2_CONFIG_QUERY_VERSION 1

typedef struct __DRI2configQueryExtensionRec __DRI2configQueryExtension;
struct __DRI2configQueryExtensionRec {
   __DRIextension base;

   int (*configQueryb)(__DRIscreen *screen, const char *var, GLboolean *val);
   int (*configQueryi)(__DRIscreen *screen, const char *var, GLint *val);
   int (*configQueryf)(__DRIscreen *screen, const char *var, GLfloat *val);
};

/**
 * Robust context driver extension.
 *
 * Existence of this extension means the driver can accept the
 * \c __DRI_CTX_FLAG_ROBUST_BUFFER_ACCESS flag and the
 * \c __DRI_CTX_ATTRIB_RESET_STRATEGY attribute in
 * \c __DRIdri2ExtensionRec::createContextAttribs.
 */
#define __DRI2_ROBUSTNESS "DRI_Robustness"
#define __DRI2_ROBUSTNESS_VERSION 1

typedef struct __DRIrobustnessExtensionRec __DRIrobustnessExtension;
struct __DRIrobustnessExtensionRec {
   __DRIextension base;
};

/**
 * DRI config options extension.
 *
 * This extension provides the XML string containing driver options for use by
 * the loader in supporting the driconf application.
 */
#define __DRI_CONFIG_OPTIONS "DRI_ConfigOptions"
#define __DRI_CONFIG_OPTIONS_VERSION 1

typedef struct __DRIconfigOptionsExtensionRec {
   __DRIextension base;
   const char *xml;
} __DRIconfigOptionsExtension;

/**
 * This extension provides a driver vtable to a set of common driver helper
 * functions (driCoreExtension, driDRI2Extension) within the driver
 * implementation, as opposed to having to pass them through a global
 * variable.
 *
 * It is not intended to be public API to the actual loader, and the vtable
 * layout may change at any time.
 */
#define __DRI_DRIVER_VTABLE "DRI_DriverVtable"
#define __DRI_DRIVER_VTABLE_VERSION 1

typedef struct __DRIDriverVtableExtensionRec {
    __DRIextension base;
    const struct __DriverAPIRec *vtable;
} __DRIDriverVtableExtension;

/**
 * Query renderer driver extension
 *
 * This allows the window system layer (either EGL or GLX) to query aspects of
 * hardware and driver support without creating a context.
 */
#define __DRI2_RENDERER_QUERY "DRI_RENDERER_QUERY"
#define __DRI2_RENDERER_QUERY_VERSION 1

#define __DRI2_RENDERER_VENDOR_ID                             0x0000
#define __DRI2_RENDERER_DEVICE_ID                             0x0001
#define __DRI2_RENDERER_VERSION                               0x0002
#define __DRI2_RENDERER_ACCELERATED                           0x0003
#define __DRI2_RENDERER_VIDEO_MEMORY                          0x0004
#define __DRI2_RENDERER_UNIFIED_MEMORY_ARCHITECTURE           0x0005
#define __DRI2_RENDERER_PREFERRED_PROFILE                     0x0006
#define __DRI2_RENDERER_OPENGL_CORE_PROFILE_VERSION           0x0007
#define __DRI2_RENDERER_OPENGL_COMPATIBILITY_PROFILE_VERSION  0x0008
#define __DRI2_RENDERER_OPENGL_ES_PROFILE_VERSION             0x0009
#define __DRI2_RENDERER_OPENGL_ES2_PROFILE_VERSION            0x000a

typedef struct __DRI2rendererQueryExtensionRec __DRI2rendererQueryExtension;
struct __DRI2rendererQueryExtensionRec {
   __DRIextension base;

   int (*queryInteger)(__DRIscreen *screen, int attribute, unsigned int *val);
   int (*queryString)(__DRIscreen *screen, int attribute, const char **val);
};

/**
 * Image Loader extension. Drivers use this to allocate color buffers
 */

enum __DRIimageBufferMask {
   __DRI_IMAGE_BUFFER_BACK = (1 << 0),
   __DRI_IMAGE_BUFFER_FRONT = (1 << 1)
};

struct __DRIimageList {
   uint32_t image_mask;
   __DRIimage *back;
   __DRIimage *front;
};

#define __DRI_IMAGE_LOADER "DRI_IMAGE_LOADER"
#define __DRI_IMAGE_LOADER_VERSION 1

struct __DRIimageLoaderExtensionRec {
    __DRIextension base;

   /**
    * Allocate color buffers.
    *
    * \param driDrawable
    * \param width              Width of allocated buffers
    * \param height             Height of allocated buffers
    * \param format             one of __DRI_IMAGE_FORMAT_*
    * \param stamp              Address of variable to be updated when
    *                           getBuffers must be called again
    * \param loaderPrivate      The loaderPrivate for driDrawable
    * \param buffer_mask        Set of buffers to allocate
    * \param buffers            Returned buffers
    */
   int (*getBuffers)(__DRIdrawable *driDrawable,
                     unsigned int format,
                     uint32_t *stamp,
                     void *loaderPrivate,
                     uint32_t buffer_mask,
                     struct __DRIimageList *buffers);

    /**
     * Flush pending front-buffer rendering
     *
     * Any rendering that has been performed to the
     * fake front will be flushed to the front
     *
     * \param driDrawable    Drawable whose front-buffer is to be flushed
     * \param loaderPrivate  Loader's private data that was previously passed
     *                       into __DRIdri2ExtensionRec::createNewDrawable
     */
    void (*flushFrontBuffer)(__DRIdrawable *driDrawable, void *loaderPrivate);
};

/**
 * DRI extension.
 */

#define __DRI_IMAGE_DRIVER           "DRI_IMAGE_DRIVER"
#define __DRI_IMAGE_DRIVER_VERSION   1

struct __DRIimageDriverExtensionRec {
   __DRIextension               base;

   /* Common DRI functions, shared with DRI2 */
   __DRIcreateNewScreen2Func            createNewScreen2;
   __DRIcreateNewDrawableFunc           createNewDrawable;
   __DRIcreateContextAttribsFunc        createContextAttribs;
   __DRIgetAPIMaskFunc                  getAPIMask;
};

#endif
