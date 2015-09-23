# Generic builder for the NVIDIA drivers, supports versions 340+

# Notice:
# The generic builder does not use the exact version changes were made, so if
# you choose to use a version not offically supported, it may require additional
# research into at which version certain changes were made.

. "${stdenv}/setup"

# Fail on any error
set -e

# PatchELF RPATH shrink removes libXv from the RPATH of `nvidia-settings', as a
# work around we run `patchelf' on everything except `nvidia-settings' (see
# `installNvidiaBin')
dontPatchELF=1

installNvidiaBin() {

  # Usage:
  # $1 - Min version (0 = null, for no minimum)
  # $2 - Max version (0 = null, for no maximum)
  # $3 - Executable name

  if ([ ${1} -eq 0 ] || [ ${versionMajor} -ge ${1} ]) && \
     ([ ${2} -eq 0 ] || [ ${versionMajor} -le ${2} ]) ; then
    # Create the executable directory if it doesn't exist
    if [ ! -d "${out}/bin" ] ; then
      mkdir -p "${out}/bin"
    fi

    # Install the executable
    cp -p "${3}" "${out}/bin"

    if [ ${versionMajor} -le 340 ] && [ "${3}" == 'nvidia-settings' ] ; then
      # For versions older than 346 add gtkPath
      patchelf \
        --set-interpreter "$(cat ${NIX_CC}/nix-support/dynamic-linker)" \
        --set-rpath "${out}/lib:${glPath}:${gtkPath}:${programPath}" \
        "${out}/bin/${3}"
    else
      patchelf \
        --set-interpreter "$(cat ${NIX_CC}/nix-support/dynamic-linker)" \
        --set-rpath "${out}/lib:${glPath}:${programPath}" \
        "${out}/bin/${3}"
    fi

    # Shrink the RPATH for all executables except `nvidia-settings'
    # Using --shrink-rpath removes libXv from the RPATH of `nvidia-settings'
    if [ "${3}" != 'nvidia-settings' ] ; then
      patchelf --shrink-rpath "${out}/bin/${3}"
    fi
  fi

}

installNvidiaHeader() {

  # Usage:
  # $1 - Min version (0 = null, for no minimum)
  # $2 - Max version (0 = null, for no maximum)
  # $3 - Header name (w/o extension (.h))
  # $4 - Include sub-directory (rel to $out/include/)

  if ([ ${1} -eq 0 ] || [ ${versionMajor} -ge ${1} ]) && \
     ([ ${2} -eq 0 ] || [ ${versionMajor} -le ${2} ]) ; then
    # Create the include directory if it doesn't exist
    if [ ! -d "${out}/include/${4}" ] ; then
      mkdir -p "${out}/include/${4}"
    fi

    # Install the header
    cp -p "${3}.h" "${out}/include/${4}"
  fi

}

installNvidiaLib() {

  # Usage:
  # $1 - Min version (0 = null, for no minimum)
  # $2 - Max version (0 = null, for no maximum)
  # $3 = Library name (w/o extension (.so*))
  # $4 = Custom so version (symlink to original) (1 is ignored since the symlink
  #      is always created, so it can be used in place of a null value)
  # $5 = File's so version
  # $6 = Lib sub-directory (rel to $out/lib/)

  local libFile
  local outDir
  local soVersion

  if ([ ${1} -eq 0 ] || [ ${versionMajor} -ge ${1} ]) && \
     ([ ${2} -eq 0 ] || [ ${versionMajor} -le ${2} ]) ; then

    # Create the lib directory if it doesn't exist
    if [ ! -d "${out}/lib/${6}" ] ; then
      mkdir -p "${out}/lib/${6}"
    fi

    # If the source *.so.<version> isn't set use *.so.$version
    if [ -z "${5}" ] ; then
      soVersion=".${version}"
    elif [ "${5}" == '-' ] ; then
      soVersion=
    else
      soVersion=".${5}"
    fi

    # If $outDir is set then we need to add a trailing `/'
    if [ -z "${6}" ] ; then
      outDir=
    else
      outDir="${6}/"
    fi

    # Handle cases where the file being installed is in a subdirectory within
    # the source directory
    libFile="$(basename "${3}")"

    # Install the library
    cp -pd "${3}.so${soVersion}" "${out}/lib/${6}"

    # Always create a symlink from the library to *.so & *.so.1
    if [ ! -z "${soVersion}" ] ; then 
      ln -srnf \
        "${out}/lib/${outDir}${libFile}.so${soVersion}" \
        "${out}/lib/${outDir}${libFile}.so"
    fi
    if [ "${soVersion}" != '.1' ] ; then
      ln -srnf \
        "${out}/lib/${outDir}${libFile}.so${soVersion}" \
        "${out}/lib/${outDir}${libFile}.so.1"
    fi

    # If $4 wasn't 1, then create a *.so.$4 symlink
    # Make sure that we don't set it if we haven't passed a value
    if [ ! -z "${4}" ] ; then
      if [ "${4}" != '-' ] && [ "${4}" != "${soVersion}" ] ; then
        ln -srnf \
          "${out}/lib/${outDir}${libFile}.so${soVersion}" \
          "${out}/lib/${outDir}${libFile}.so.${4}"
      fi
    fi

    patchelf --set-rpath \
      "${out}/lib:${allLibPath}" \
      "${out}/lib/${outDir}${libFile}.so${soVersion}"

    patchelf --shrink-rpath "${out}/lib/${outDir}${libFile}.so${soVersion}"

  fi

}

installNvidiaMan() {

  # Usage:
  # $1 - Min version (0 = null, for no minimum)
  # $2 - Max version (0 = null, for no maximum)
  # $3 = Man page (w/o extension (.1.gz))

  if ([ ${1} -eq 0 ] || [ ${versionMajor} -ge ${1} ]) && \
     ([ ${2} -eq 0 ] || [ ${versionMajor} -le ${2} ]) ; then
    # Create the manpage directory if it doesn't exist
    if [ ! -d "${out}/share/man/man1" ] ; then
      mkdir -p "${out}/share/man/man1"
    fi

    # Install the manpage
    cp -p "${3}.1.gz" "${out}/share/man/man1"
  fi

}

unpackFile() {

  # This function prints the first 20 lines of the file, then awk's for the line
  # with `skip=' which contains the line number where the tarball begins, then
  # tails to that line and pipes the tarball to the required decompression
  # utility (gzip/lzma), which interprets the tarball, and finally pipes the
  # output to tar to extract the contents. This is exactly what the cli commands
  # in the `.run' file do, but there is an issue with some versions so it is
  # best to do it manually instead.

  local skip

  # The line you are looking for `skip=' is within the first 20 lines of the
  # file, make sure that you aren't grepping/awking/sedding the entire 60,000+
  # line file for 1 line (hense the use of `head').
  skip="$(
    head -n 20 "${src}" |
    awk -F= '/skip=/ { print $2 ; exit ; }' |
    grep -o '[0-9]*'
  )"

  # If the `skip=' value is null, more than likely the hash wasn't updated after
  # bumping the version.
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

    # $src is also used by the nv makefile
    unset src

    make SYSSRC="${kernelSource}" SYSOUT="${kernelBuild}" module

    # Versions 355+ combines the make files for all kernel modules. So for older
    # versions make sure to build the Cuda UVM module
    if [ ${versionMajor} -lt 355 ] && \
       [ ${versionMajor} -ge 340 ] ; then
      # 32-bit UVM support was removed in 346
      if ([ ${versionMajor} -ge 346 ] && \
         [ "${system}" == 'x86_64-linux' ]) || \
         [ ${versionMajor} -lt 346 ] ; then
        cd "${sourceRoot}/kernel/uvm"
        make SYSSRC="${kernelSource}" SYSOUT="${kernelBuild}" module
      fi
    fi

    cd "${sourceRoot}"

  fi

}

nvidiaKernelspace() {

  # Install the kernel modules
  mkdir -p "${out}/lib/modules/${kernelVersion}/misc"

  nuke-refs 'kernel/nvidia.ko'
  cp -p \
    'kernel/nvidia.ko' \
    "${out}/lib/modules/${kernelVersion}/misc"

  if [ ${versionMajor} -ge 340 ] && [ ${versionMajor} -lt 346 ] ; then
    if [ ${versionMajor} -ge 355 ] ; then
      nuke-refs 'kernel/nvidia-uvm.ko'
      cp -p \
        'kernel/nvidia-uvm.ko' \
        "${out}/lib/modules/${kernelVersion}/misc"
    else
      nuke-refs 'kernel/uvm/nvidia-uvm.ko'
      cp -p \
        'kernel/uvm/nvidia-uvm.ko' \
        "${out}/lib/modules/${kernelVersion}/misc"
    fi
  fi

}

nvidiaUserspace() {

  #
  ## Libraries
  #

    # Graphics libraries
      # OpenGL API entry point
      installNvidiaLib  0  0  'libGL'
      installNvidiaLib 0 173 'libGLcore'
      # OpenGL ES API entry point
      installNvidiaLib 340 0 'libGLESv1_CM'
      installNvidiaLib 340 0 'libGLESv2' '2'
      # EGL API entry point
      installNvidiaLib 340 354 'libEGL' # Renamed to *.so.1 in 355+
      installNvidiaLib 355 0 'libEGL' '-' '1'
      installNvidiaLib 355 0 'libEGL_nvidia' '-' '0'

    # Vendor neutral graphics libraries
      installNvidiaLib 355 0 'libOpenGL' '-' '0'
      installNvidiaLib 355 0 'libGLdispatch' '-' '0'

    # Internal driver components
      installNvidiaLib 340 0 'libnvidia-eglcore'
      installNvidiaLib 304 0 'libnvidia-glcore'
      installNvidiaLib 340 0 'libnvidia-glsi'

    # NVIDIA OpenGL-based inband frame readback
      installNvidiaLib 340 0 'libnvidia-ifr'

    # Thread local storage libraries for NVIDIA OpenGL libraries
      installNvidiaLib 304 0 'libnvidia-tls'
      installNvidiaLib 0 0 'tls/libnvidia-tls' '1' "${version}" 'tls'
      ###installNvidiaLib 0 0 'tls_test_dso' '1' '-'
      ###installNvidiaLib 0 0 'tls_test'

    # X.Org DDX driver
      if test -z "${libsOnly}" ; then
        installNvidiaLib 0 0 'nvidia_drv' '1' '-' 'xorg/modules/drivers'
      fi

    # X.Org GLX extension module
      if test -z "${libsOnly}" ; then
        installNvidiaLib 0 0 'libglx' '1' "${version}" 'xorg/modules/extensions'
      fi

    # VDPAU libraries
      # https://devtalk.nvidia.com/default/topic/873035
      # Distributed seperately in `libvdpau'
      # https://github.com/aaronp24/libvdpau
      # Top-level wrapper
      ###installNvidiaLib 0 0 'libvdpau'
      # Debug trace library
      ###installNvidiaLib 0 0 'libvdpau_trace'
      # NVIDIA VDPAU implementation
      installNvidiaLib 304 0 'libvdpau_nvidia'

    # Managment & Monitoring library
      installNvidiaLib 304 0 'libnvidia-ml'

    # CUDA libraries
      installNvidiaLib 0 0 'libcuda'
      installNvidiaLib 304 0 'libnvidia-compiler'
      # CUDA video decoder library
      installNvidiaLib 0 0 'libnvcuvid'

    # OpenCL libraries
      # Vendor independent ICD loader
      installNvidiaLib 304 0 'libOpenCL' '1' '1.0.0'
      # NVIDIA ICD
      installNvidiaLib 304 0 'libnvidia-opencl'

    # Linux kernel userspace driver config library
      installNvidiaLib 0 0 'libnvidia-cfg'

    # Wrapped software rendering library
      if test -z "${libsOnly}" ; then
        installNvidiaLib 0 0 'libnvidia-wfb' '1' "${version}" 'xorg/modules'
      fi

    # Framebuffer capture library
      installNvidiaLib 0 0 'libnvidia-fbc'

    # NVENC video encoding library
      if test -z "${libsOnly}" ; then
        installNvidiaLib 0 0 'libnvidia-encode'
      fi

    # NVIDIA GTK+ 2/3 libraries
      # For versions older than 346 see installNvidiaBin
      if test -n "${nvidiasettingsSupport}" && \
         test -z "${libsOnly}" && \
         [ ${versionMajor} -ge 346 ] ; then
        if test -n "${gtk3Support}" ; then
          installNvidiaLib 346 0 'libnvidia-gtk3'
          patchelf --set-rpath \
            "${out}/lib:${glPath}:${gtkPath}" \
            "${out}/lib/libnvidia-gtk3.so.${version}"
        else
          installNvidiaLib 346 0 'libnvidia-gtk2'
          patchelf --set-rpath \
            "${out}/lib:${glPath}:${gtkPath}" \
            "${out}/lib/libnvidia-gtk2.so.${version}"
        fi
      fi

  #
  ## Headers
  #

    if test -z "${libsOnly}" ; then
      # Cuda headers
        installNvidiaHeader 0 173 'cuda' 'cuda'
        installNvidiaHeader 0 173 'cudaGL' 'cuda'

      # OpenGL headers
        installNvidiaHeader 0 0 'gl' 'GL'
        installNvidiaHeader 0 0 'glext' 'GL'
        installNvidiaHeader 0 0 'glx' 'GL'
        installNvidiaHeader 0 0 'glxext' 'GL'
    fi

  #
  ## Executables (support programs)
  #

    if test -z "${libsOnly}" ; then
      ###installNvidiaBin 0 0 'mkprecompiled'
      ###installNvidiaBin 0 0 'nvidia-bug-report.sh'
      installNvidiaBin 340 0 'nvidia-cuda-mps-control'
      installNvidiaBin 340 0 'nvidia-cuda-mps-server'
      installNvidiaBin 304 304 'nvidia-cuda-proxy-control'
      installNvidiaBin 304 304 'nvidia-cuda-proxy-server'
      installNvidiaBin 304 0 'nvidia-debugdump'
      ###installNvidiaBin 0 0 'nvidia-installer'
      ###installNvidiaBin 340 0 'nvidia-modprobe'
      installNvidiaBin 340 0 'nvidia-persistenced'
      if test -n "${nvidiasettingsSupport}" ; then
        installNvidiaBin 0 0 'nvidia-settings'
      fi
      # System Management Interface
      installNvidiaBin 0 0 'nvidia-smi'
      ###installNvidiaBin 0 0 'nvidia-xconfig'
      ###installNvidiaBin 0 0 'tls_test' (also tls_test.so)
    fi

  #
  ## Manpages
  #

    if test -z "${libsOnly}" ; then
      installNvidiaMan 0 0 'nvidia-cuda-mps-control'
      ###installNvidiaMan 0 0 'nvidia-installer'
      ###installNvidiaMan 0 0 'nvidia-modprobe'
      installNvidiaMan 0 0 'nvidia-persistenced'
      if test -n "${nvidiasettingsSupport}" ; then
        installNvidiaMan 0 0 'nvidia-settings'
      fi
      installNvidiaMan 0 0 'nvidia-smi'
      ###installNvidiaMan 0 0 'nvidia-xconfig'
    fi

  #
  ## Configs
  #

    if test -z "${libsOnly}" ; then
      # NVIDIA application profiles
        mkdir -p "${out}/share/doc"
        cp -p \
          "nvidia-application-profiles-${version}-key-documentation" \
          "${out}/share/doc"
        cp -p \
          "nvidia-application-profiles-${version}-rc" \
          "${out}/share/doc"

      # OpenCL ICD config
        mkdir -p "${out}/lib/vendors"
        cp -p 'nvidia.icd' "${out}/lib/vendors"
    fi

  #
  ## Desktop Entries
  #

    if test -z "${libsOnly}" ; then
      if test -n "${nvidiasettingsSupport}" ; then
        # NVIDIA Settings .desktop entry
          mkdir -p "${out}/share/applications"
          cp -p 'nvidia-settings.desktop' "${out}/share/applications"
          substituteInPlace \
            "${out}/share/applications/nvidia-settings.desktop" \
            --replace '__UTILS_PATH__' "${out}/bin" \
            --replace '__PIXMAP_PATH__' "${out}/share/pixmaps"
      fi
    fi

  #
  ## Icons
  #

    if test -z "${libsOnly}" ; then
      if test -n "${nvidiasettingsSupport}" ; then
        # NVIDIA Settings icon
          mkdir -p "${out}/share/pixmaps"
          cp -p \
            'nvidia-settings.png' \
            "${out}/share/pixmaps"
      fi
    fi

  #
  ## Tests
  #

    if test -z "${libsOnly}" && test -n "${nvidiasettingsSupport}" ; then
      ${out}/bin/nvidia-settings --version
    fi

}

installPhase() {

  # Kernelspace
  if test -n "${buildKernelspace}" ; then
    nvidiaKernelspace
  fi

  # Userspace
  if test -n "${buildUserspace}" ; then
    nvidiaUserspace
  fi

}

genericBuild

set +e
