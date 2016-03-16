# Generic builder for the NVIDIA drivers, supports versions 304+

# Notice:
# The generic builder does not always use the exact version changes were made,
# so if you choose to use a version not offically supported, it may require
# additional research into at which version certain changes were made.

source "${stdenv}/setup"

# Fail on any error
set -e

# PatchELF RPATH shrink removes libXv from the RPATH of `nvidia-settings',
# as a work around we run `patchelf' on everything except `nvidia-settings'
# (see `nvidia_patchelf`)
dontPatchELF=1

nvidia_bin_install() {
  # Usage:
  # $1 - Min version (0 = null, for no minimum)
  # $2 - Max version (0 = null, for no maximum)
  # $3 - Executable name w/ relative path

  if ([ ${1} -eq 0 ] || [ ${versionMajor} -ge ${1} ]) && \
     ([ ${2} -eq 0 ] || [ ${versionMajor} -le ${2} ]) ; then
    # Install the executable
    install -D -m 755 -v "${3}" "${out}/bin/$(basename ${3})"
  fi
}

nvidia_header_install() {
  # Usage:
  # $1 - Min version (0 = null, for no minimum)
  # $2 - Max version (0 = null, for no maximum)
  # $3 - Header name w/ relative path & w/o extension (.h)
  # $4 - Install include sub-directory (relative to $out/include/)

  if ([ ${1} -eq 0 ] || [ ${versionMajor} -ge ${1} ]) && \
     ([ ${2} -eq 0 ] || [ ${versionMajor} -le ${2} ]) ; then
    # Install the header
    install -D -m 644 -v "${3}.h" "${out}/include${4:+/${4}}/$(basename ${3}).h"
  fi
}

nvidia_lib_install() {
  # Usage:
  # $1 - Min version (0 = null, for no minimum)
  # $2 - Max version (0 = null, for no maximum)
  # $3 - Library name w/ relative path & w/o extension (.so*)
  # $4 - Custom shared object version (symlink *.so.<orig> -> *.so.<custom>)
  # $5 - Source libraries' shared object version (*.so.<version>)
  # $6 - Install library in sub-directory (relative to $out/lib/)

  local libFile
  local outDir
  local soVersion

  if ([ ${1} -eq 0 ] || [ ${versionMajor} -ge ${1} ]) && \
     ([ ${2} -eq 0 ] || [ ${versionMajor} -le ${2} ]) ; then
    # If the source *.so.<version> isn't set use *.so.$version
    if [ -z "${5}" ] ; then
      soVersion="${version}"
    elif [ "${5}" == '-' ] ; then
      unset soVersion
    else
      soVersion="${5}"
    fi

    # Handle cases where the file being installed is in a subdirectory within
    # the source directory
    libFile="$(basename "${3}")"

    # Install the library
    install -D -m 755 -v "${3}.so${soVersion:+.${soVersion}}" \
      "${out}/lib${6:+/${6}}/${libFile}.so${soVersion:+.${soVersion}}"

    # Always create a symlink from the library to *.so
    if [ ! -z "${soVersion}" ] ; then
      ln -fnrsv \
        "${out}/lib${6:+/${6}}/${libFile}.so.${soVersion}" \
        "${out}/lib${6:+/${6}}/${libFile}.so"
    fi

    # If $4 is set & does not equal $soVersion, then create a *.so.$4 symlink
    if [ ! -z "${4}" ] && [ "${4}" != '-' ] && [ "${4}" != "${soVersion}" ] ; then
      ln -fnrsv \
        "${out}/lib${6:+/${6}}/${libFile}.so${soVersion:+.${soVersion}}" \
        "${out}/lib${6:+/${6}}/${libFile}.so.${4}"
    fi
  fi
}

nvidia_man_install() {
  # Usage:
  # $1 - Min version (0 = null, for no minimum)
  # $2 - Max version (0 = null, for no maximum)
  # $3 - Man page (w/o extension (.1.gz))

  if ([ ${1} -eq 0 ] || [ ${versionMajor} -ge ${1} ]) && \
     ([ ${2} -eq 0 ] || [ ${versionMajor} -le ${2} ]) ; then
    # Install the manpage
    install -D -m 644 -v "${3}.1.gz" \
      "${out}/share/man/man1/$(basename ${3}).1.gz"
  fi
}

nvidia_patchelf() {
  local executable
  local patchLib

  find "${out}/lib" -name '*.so*' -type f |
  while read -r patchLib ; do
    if [ -f "${patchLib}" ] ; then
      echo "patchelf: ${patchLib} : rpath -> ${out}/lib:${allLibPath}"
      patchelf \
        --set-rpath "${out}/lib:${allLibPath}" \
        "${patchLib}"
      echo "patchelf: ${patchLib} : shrink-rpath"
      patchelf --shrink-rpath "${patchLib}"
    fi
  done

  for executable in $out/bin/* ; do
    if [ -f "${executable}" ] ; then
      echo "patchelf: ${executable} : rpath -> ${out}/lib:${allLibPath}"
      patchelf \
        --set-interpreter "$(cat ${NIX_CC}/nix-support/dynamic-linker)" \
        --set-rpath "${out}/lib:${allLibPath}" \
        "${executable}"
      echo "patchelf: ${executable} : shrink-rpath"
      patchelf --shrink-rpath "${executable}"
    fi
  done
}

unpackFile() {
  # This function prints the first 20 lines of the file, then awk's for
  # the line with `skip=` which contains the line number where the tarball
  # begins, then tails to that line and pipes the tarball to the required
  # decompression utility (gzip/xz), which interprets the tarball, and
  # finally pipes the output to tar to extract the contents. This is
  # exactly what the cli commands in the `.run` file do, but there is an
  # issue with some versions so it is best to do it manually instead.

  local skip

  # The line you are looking for `skip=` is within the first 20 lines of
  # the file, make sure that you aren't grepping/awking/sedding the entire
  # 60,000+ line file for 1 line (hense the use of `head`).
  skip="$(
    head --lines 20 "${src}" |
      awk -F= '/skip=/ { print $2 ; exit }' |
      grep --only-matching '[0-9]*'
  )"

  # If the `skip=' value is null, more than likely the hash wasn't updated
  # after bumping the version.
  [ ! -z "${skip}" ]

  if [ ${versionMajor} -le 304 ] ; then
    tail -n +"${skip}" "${src}" | gzip -cd | tar xvf -
  else
    tail -n +"${skip}" "${src}" | xz -d | tar xvf -
  fi

  sourceRoot="$(pwd)"
  export sourceRoot
}

buildPhase() {
  local kernelBuild
  local kernelSource

  if test -n "${buildKernelspace}" ; then
    # Create the kernel module
    echo "Building the NVIDIA Linux kernel modules against: ${kernel}"

    cd "${sourceRoot}/kernel"

    kernelVersion="$(ls "${kernel}/lib/modules")"
    [ ! -z "${kernelVersion}" ]
    kernelSource="${kernel}/lib/modules/${kernelVersion}/source"
    kernelBuild="${kernel}/lib/modules/${kernelVersion}/build"

    # $src is also used by the makefile
    unset src

    make \
      SYSSRC="${kernelSource}" \
      SYSOUT="${kernelBuild}" \
      -j${NIX_BUILD_CORES} \
      -l${NIX_BUILD_CORES} \
      module

    # Versions 355+ combines the make files for all kernel modules. So for
    # older versions make sure to build the Cuda UVM module
    if [ ${versionMajor} -lt 355 ] && \
       [ ${versionMajor} -ge 340 ] ; then
      # 32-bit UVM support was removed in 346
      if ([ ${versionMajor} -ge 346 ] && \
         [ "${system}" == 'x86_64-linux' ]) || \
         [ ${versionMajor} -lt 346 ] ; then
        cd "${sourceRoot}/kernel/uvm"
        make \
          SYSSRC="${kernelSource}" \
          SYSOUT="${kernelBuild}" \
          -j${NIX_BUILD_CORES} \
          -l${NIX_BUILD_CORES} \
          module
      fi
    fi

    cd "${sourceRoot}"
  fi
}

installPhase() {
  ###############
  # Kernelspace #
  ###############
  nvidia_kernelspace() {
    #
    ## Kernel modules
    #

    # NVIDIA kernel module
    nuke-refs 'kernel/nvidia.ko'
    install -D -m 644 -v 'kernel/nvidia.ko' \
      "${out}/lib/modules/${kernelVersion}/misc/nvidia.ko"

    # NVIDIA modesetting kernel module
    if [ ${versionMajor} -ge 358 ] ; then
      nuke-refs 'kernel/nvidia-modeset.ko'
      install -D -m 644 -v 'kernel/nvidia-modeset.ko' \
        "${out}/lib/modules/${kernelVersion}/misc/nvidia-modeset.ko"
    fi

    # NVIDIA cuda unified virtual memory kernel module
    if [ ${versionMajor} -ge 340 ] ; then
      # The uvm kernel module build directory changed in 355+
      if [ ${versionMajor} -ge 355 ] && [ "${system}" == 'x86_64-linux' ] ; then
        nuke-refs 'kernel/nvidia-uvm.ko'
        install -D -m 644 -v 'kernel/nvidia-uvm.ko' \
          "${out}/lib/modules/${kernelVersion}/misc/nvidia-uvm.ko"
      elif ([ ${versionMajor} -ge 346 ] && [ "${system}" == 'x86_64-linux' ]) || \
           ([ ${versionMajor} -ge 340 ] && [ ${versionMajor} -lt 346 ]) ; then
        nuke-refs 'kernel/uvm/nvidia-uvm.ko'
        install -D -m 644 -v 'kernel/uvm/nvidia-uvm.ko' \
          "${out}/lib/modules/${kernelVersion}/misc/nvidia-uvm.ko"
      fi
    fi

    #
    ## Executables
    #

    nvidia_bin_install 340 0 'nvidia-cuda-mps-control'
    nvidia_bin_install 340 0 'nvidia-cuda-mps-server'
    nvidia_bin_install 304 304 'nvidia-cuda-proxy-control'
    nvidia_bin_install 304 304 'nvidia-cuda-proxy-server'
    ###nvidia_bin_install 340 0 'nvidia-modprobe'
    nvidia_bin_install 340 0 'nvidia-persistenced'
    # System Management Interface
    nvidia_bin_install 0 0 'nvidia-smi'

    #
    ## Manpages
    #

    nvidia_man_install 340 0 'nvidia-cuda-mps-control'
    nvidia_man_install 304 304 'nvidia-cuda-proxy-control'
    ###nvidia_man_install 0 0 'nvidia-modprobe'
    nvidia_man_install 340 0 'nvidia-persistenced'
    nvidia_man_install 0 0 'nvidia-smi'
  }
  if test -n "${buildKernelspace}" ; then
    nvidia_kernelspace
  fi

  #############
  # Userspace #
  #############
  nvidia_userspace() {
    #
    ## Libraries
    #

    ## Graphics libraries
    # OpenGL GLX API entry point (NVIDIA)
    # - Triton only supports the NVIDIA vendor libGL implementation for
    #   versions that do not support GLVND (<361).
    nvidia_lib_install 0 360 'libGL' '1'
    # OpenGL GLX API entry point (GLVND)
    nvidia_lib_install 361 0 'libGL' '1' '1.0.0'
    # OpenGL ES API entry point
    nvidia_lib_install 340 360 'libGLESv1_CM' '1' # Renamed to *.so.1 in 361+
    nvidia_lib_install 361 0 'libGLESv1_CM' '-' '1'
    nvidia_lib_install 340 360 'libGLESv2' '2' # Renamed to *.so.2 in 361+
    nvidia_lib_install 361 0 'libGLESv2' '-' '2'
    # EGL API entry point
    nvidia_lib_install 340 354 'libEGL' # Renamed to *.so.1 in 355+
    nvidia_lib_install 355 0 'libEGL' '-' '1'

    ## Vendor neutral graphics libraries
    nvidia_lib_install 355 0 'libOpenGL' '-' '0'
    nvidia_lib_install 361 0 'libGLX' '-' '0'
    nvidia_lib_install 355 0 'libGLdispatch' '-' '0'

    ## Vendor implementation graphics libraries
    nvidia_lib_install 361 0 'libGLX_nvidia' '0'
    nvidia_lib_install 361 0 'libEGL_nvidia' '0'
    nvidia_lib_install 361 0 'libGLESv1_CM_nvidia' '1'
    nvidia_lib_install 361 0 'libGLESv2_nvidia' '2'
    nvidia_lib_install 304 0 'libvdpau_nvidia'

    # GLX indirect support
    # CVE-2014-8298: http://goo.gl/QTEVwu
    #ln -fsv \
    #  "${out}/lib/libGLX_nvidia.${version}" \
    #  "${out}/lib/libGLX_indirect.so.0"

    ## Internal driver components
    nvidia_lib_install 340 0 'libnvidia-eglcore'
    nvidia_lib_install 304 0 'libnvidia-glcore'
    nvidia_lib_install 340 0 'libnvidia-glsi'

    # NVIDIA OpenGL-based inband frame readback
    nvidia_lib_install 340 0 'libnvidia-ifr'

    ## Thread local storage libraries for NVIDIA OpenGL libraries
    nvidia_lib_install 304 0 'libnvidia-tls'
    nvidia_lib_install 0 0 'tls/libnvidia-tls' '-' "${version}" 'tls'
    ###nvidia_lib_install 0 0 'tls_test_dso' '-' '-'

    # X.Org DDX driver
    if test -z "${libsOnly}" ; then
      nvidia_lib_install 0 0 'nvidia_drv' '-' '-' 'xorg/modules/drivers'
    fi

    # X.Org GLX extension module
    if test -z "${libsOnly}" ; then
      nvidia_lib_install 0 0 'libglx' '-' "${version}" 'xorg/modules/extensions'
    fi

    # X-Video Motion Compensation library
    nvidia_lib_install 0 304 'libXvMCNVIDIA' '1'

    # Managment & Monitoring library
    nvidia_lib_install 304 0 'libnvidia-ml' '1'

    ## CUDA libraries
    nvidia_lib_install 0 0 'libcuda'
    nvidia_lib_install 304 0 'libnvidia-compiler'
    # CUDA video decoder library
    nvidia_lib_install 0 0 'libnvcuvid' '1'
    # Fat (multiarchitecture) binary loader
    nvidia_lib_install 361 0 'libnvidia-fatbinaryloader'
    # Parallel Thread Execution JIT Compiler for CUDA
    nvidia_lib_install 361 0 'libnvidia-ptxjitcompiler'

    ## OpenCL libraries
    # Vendor independent ICD loader
    nvidia_lib_install 304 0 'libOpenCL' '1' '1.0.0'
    # NVIDIA ICD
    nvidia_lib_install 304 0 'libnvidia-opencl'

    # Linux kernel userspace driver config library
    nvidia_lib_install 0 0 'libnvidia-cfg'

    # Wrapped software rendering library
    if test -z "${libsOnly}" ; then
      nvidia_lib_install 0 0 'libnvidia-wfb' '-' "${version}" 'xorg/modules'
      # symlink libwfb -> libnvidia-wfb
      ln -fsv \
        "${out}/lib/xorg/modules/libnvidia-wfb.so.${version}" \
        "${out}/lib/xorg/modules/libwfb.so"
    fi

    # Framebuffer capture library
    nvidia_lib_install 340 0 'libnvidia-fbc'

    # NVENC video encoding library
    nvidia_lib_install 340 0 'libnvidia-encode'

    # NVIDIA GTK+ 3 library
    # For versions older than 346 see nvidia_bin_install
    if test -n "${nvidiasettingsSupport}" && \
       test -z "${libsOnly}" && \
       [ ${versionMajor} -ge 346 ] ; then
      nvidia_lib_install 346 0 'libnvidia-gtk3'
    fi

    #
    ## Headers
    #

    if test -z "${libsOnly}" ; then
      ## OpenGL headers
      nvidia_header_install 0 0 'gl' 'GL'
      nvidia_header_install 0 0 'glext' 'GL'
      nvidia_header_install 0 0 'glx' 'GL'
      nvidia_header_install 0 0 'glxext' 'GL'
    fi

    #
    ## Executables
    #

    if test -z "${libsOnly}" ; then
      ###nvidia_bin_install 0 0 'mkprecompiled'
      ###nvidia_bin_install 0 0 'nvidia-bug-report.sh'
      nvidia_bin_install 304 0 'nvidia-debugdump'
      ###nvidia_bin_install 0 0 'nvidia-installer'
      if test -n "${nvidiasettingsSupport}" ; then
        nvidia_bin_install 0 0 'nvidia-settings'
      fi
      ###nvidia_bin_install 0 0 'nvidia-xconfig'
      ###nvidia_bin_install 0 0 'tls_test' (also tls_test.so)
    fi

    #
    ## Manpages
    #

    if test -z "${libsOnly}" ; then
      ###nvidia_man_install 361 0 'nvidia-gridd'
      ###nvidia_man_install 0 0 'nvidia-installer'
      if test -n "${nvidiasettingsSupport}" ; then
        nvidia_man_install 0 0 'nvidia-settings'
      fi
      ###nvidia_man_install 0 0 'nvidia-xconfig'
    fi

    #
    ## Configs
    #

    if test -z "${libsOnly}" ; then
      # NVIDIA application profiles
      if [ ${versionMajor} -ge 340 ] ; then
        install -D -m 644 -v "nvidia-application-profiles-${version}-key-documentation" \
          "${out}/share/doc/nvidia-application-profiles-${version}-key-documentation"
        install -D -m 644 -v "nvidia-application-profiles-${version}-rc" \
          "${out}/share/doc/nvidia-application-profiles-${version}-rc"
        mkdir -pv "${out}/etc/nvidia"
        ln -fsv \
          "${out}/share/doc/nvidia-application-profiles-${version}-rc" \
          "${out}/etc/nvidia/nvidia-application-profiles-rc.d"
      fi

      # OpenCL ICD config
      install -D -m 644 -v 'nvidia.icd' "${out}/etc/OpenCL/vendors/nvidia.icd"

      # X.Org driver configuration file
      if [ ${versionMajor} -ge 346 ] ; then
        install -D -m 644 -v 'nvidia-drm-outputclass.conf' \
          "$out/share/X11/xorg.conf.d/nvidia-drm-outputclass.conf"
      fi
    fi

    #
    ## Desktop Entries
    #

    if test -z "${libsOnly}" ; then
      if test -n "${nvidiasettingsSupport}" ; then
        # NVIDIA Settings .desktop entry
        install -D -m 644 -v 'nvidia-settings.desktop' \
          "${out}/share/applications/nvidia-settings.desktop"
        sed -i "${out}/share/applications/nvidia-settings.desktop" \
          -e "s,__UTILS_PATH__,${out}/bin," \
          -e "s,__PIXMAP_PATH__,${out}/share/pixmaps,"
      fi
    fi

    #
    ## Icons
    #

    if test -z "${libsOnly}" ; then
      if test -n "${nvidiasettingsSupport}" ; then
        # NVIDIA Settings icon
        install -D -m 644 -v 'nvidia-settings.png' \
          "${out}/share/pixmaps/nvidia-settings.png"
      fi
    fi
  }
  if test -n "${buildUserspace}" ; then
    nvidia_userspace
  fi
}

preFixup() {
  # Patch RPATH's in libraries and executables
  nvidia_patchelf

  # nvidia-settings special case
  if test -z "${libsOnly}" && test -n "${nvidiasettingsSupport}" ; then
    # Handle GTK+ path for nvidia-settings separately
    if [ ${versionMajor} -ge 346 ] ; then
      # NVIDIA GTK+3 library
      local gtkLib="${out}/lib/libnvidia-gtk3.so.${version}"
      if [ -f "${gtkLib}" ] ; then
        echo "patchelf: ${gtkLib} : rpath -> ${out}/lib:${allLibPath}:${gtkPath}"
        patchelf \
          --set-rpath "${out}/lib:${allLibPath}:${gtkPath}" \
          "${gtkLib}"
        echo "patchelf: ${gtkLib} : shrink-rpath"
        patchelf --shrink-rpath "${gtkLib}"
      fi
    else
      local nvSetBin="${out}/bin/nvidia-settings"
      if [ -f "${nvSetBin}" ] ; then
        echo "patchelf: ${nvSetBin} : rpath -> ${out}/lib:${allLibPath}:${gtkPath}"
        patchelf \
          --set-rpath "${out}/lib:${allLibPath}:${gtkPath}" \
          "${nvSetBin}"
        echo "patchelf: ${nvSetBin} : shrink-rpath"
        patchelf --shrink-rpath "${nvSetBin}"
      fi
    fi

    # nvidia-settings loads libXv at runtime, so shrink rpath
    # strips it out; re-add libXv here.
    if [ -f "$out/bin/nvidia-settings" ] && \
       test -n "${nvidiasettingsSupport}" ; then
      local storeNvSettingsRpath
      storeNvSettingsRpath="$(patchelf --print-rpath $out/bin/nvidia-settings)"
      storeNvSettingsRpath="${storeNvSettingsRpath}:${libXvPath}"
      echo "patchelf: ${out}/bin/nvidia-settings : rpath -> ${storeNvSettingsRpath}"
      patchelf \
        --set-rpath "${storeNvSettingsRpath}" \
        "${out}/bin/nvidia-settings"
    fi
  fi
}

# Run some tests
postFixup() {
  # This only guarantees that libc rpath's were patched successfully
  if test -z "${libsOnly}" && test -n "${nvidiasettingsSupport}" ; then
    ${out}/bin/nvidia-settings --version
  fi

  # Fail if libraries contain broken RPATH's
  local TestLib
  find "${out}/lib" -name '*.so*' -type f |
  while read -r TestLib ; do
    echo "Testing rpath for: ${TestLib}"
    if [ -n "$(ldd "${TestLib}" 2> /dev/null |
               grep --only-matching 'not found')" ] ; then
      echo "ERROR: failed to patch RPATH's for:"
      echo "${TestLib}"
      ldd ${TestLib}
      return 1
    fi
    echo "PASSED"
  done

  # Fail if executables contain broken RPATH's
  local executable
  for executable in ${out}/bin/* ; do
    echo "Testing rpath for: ${executable}"
    if [ -n "$(ldd "${executable}" 2> /dev/null |
               grep --only-matching 'not found')" ] ; then
      echo "ERROR: failed to patch RPATH's for:"
      echo "${executable}"
      ldd ${out}/bin/${executable}
      return 1
    fi
    echo "PASSED"
  done
}

genericBuild

set +e