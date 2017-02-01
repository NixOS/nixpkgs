source $stdenv/setup

dontPatchELF=1 # must keep libXv, $out in RPATH


unpackFile() {
    skip=$(sed 's/^skip=//; t; d' $src)
    tail -n +$skip $src | xz -d | tar xvf -
    sourceRoot=.
}


buildPhase() {
    if test -z "$libsOnly"; then
        # Create the module.
        echo "Building linux driver against kernel: $kernel";
        cd kernel
        kernelVersion=$(cd $kernel/lib/modules && ls)
        sysSrc=$(echo $kernel/lib/modules/$kernelVersion/source)
        sysOut=$(echo $kernel/lib/modules/$kernelVersion/build)
        unset src # used by the nv makefile
        make SYSSRC=$sysSrc SYSOUT=$sysOut module -j$NIX_BUILD_JOBS

        cd ..
    fi
}


installPhase() {
    # Install libGL and friends.
    mkdir -p "$out/etc/OpenCL/vendors"
    cp -p nvidia.icd $out/etc/OpenCL/vendors/

    mkdir -p "$out/share/vulkan/icd.d"
    cp -p nvidia_icd.json "$out/share/vulkan/icd.d/"

    mkdir -p "$out/lib"
    cp -prd *.so.* tls "$out/lib/"
    rm "$out"/lib/lib{glx,nvidia-wfb}.so.* # handled separately

    rm $out/lib/libGL.so.1.* # GLVND
    rm $out/lib/libOpenCL.so* # ocl-icd is used instead

    if test -z "$libsOnly"; then
        # Install the X drivers.
        mkdir -p $out/lib/xorg/modules
        cp -p libnvidia-wfb.* $out/lib/xorg/modules/
        mkdir -p $out/lib/xorg/modules/drivers
        cp -p nvidia_drv.so $out/lib/xorg/modules/drivers
        mkdir -p $out/lib/xorg/modules/extensions
        cp -p libglx.so.* $out/lib/xorg/modules/extensions

        # Install the kernel module.
        mkdir -p $out/lib/modules/$kernelVersion/misc
        for i in $(find ./kernel -name '*.ko'); do
            nuke-refs $i
            cp $i $out/lib/modules/$kernelVersion/misc/
        done
    fi

    # All libs except GUI-only are in $out now, so fixup them.
    for libname in `find "$out/lib/" -name '*.so.*'`
    do
      # I'm lazy to differentiate needed libs per-library, as the closure is the same.
      # Unfortunately --shrink-rpath would strip too much.
      patchelf --set-rpath "$out/lib:$allLibPath" "$libname"

      libname_short=`echo -n "$libname" | sed 's/so\..*/so/'`

      if [[ "$libname" != "$libname_short" ]]; then
        ln -srnf "$libname" "$libname_short"
      fi

      if [[ $libname_short =~ libEGL.so || $libname_short =~ libEGL_nvidia.so || $libname_short =~ libGLX.so || $libname_short =~ libGLX_nvidia.so ]]; then
          major=0
      else
          major=1
      fi

      if [[ "$libname" != "$libname_short.$major" ]]; then
        ln -srnf "$libname" "$libname_short.$major"
      fi
    done

    #patchelf --set-rpath $out/lib:$glPath $out/lib/libGL.so.*.*
    #patchelf --set-rpath $out/lib:$glPath $out/lib/libvdpau_nvidia.so.*.*
    #patchelf --set-rpath $cudaPath $out/lib/libcuda.so.*.*
    #patchelf --set-rpath $openclPath $out/lib/libnvidia-opencl.so.*.*

    if test -z "$libsOnly"; then
        # Install headers and /share files etc.
        mkdir -p $out/include/nvidia
        cp -p *.h $out/include/nvidia

        mkdir -p $out/share/man/man1
        cp -p *.1.gz $out/share/man/man1
        rm $out/share/man/man1/nvidia-xconfig.1.gz

        mkdir -p $out/share/applications
        cp -p *.desktop $out/share/applications

        mkdir -p $out/share/pixmaps
        cp -p nvidia-settings.png $out/share/pixmaps

        # Patch the `nvidia-settings.desktop' file.
        substituteInPlace $out/share/applications/nvidia-settings.desktop \
            --replace '__UTILS_PATH__' $out/bin \
            --replace '__PIXMAP_PATH__' $out/share/pixmaps


        # Install the programs.
        mkdir -p $out/bin

        for i in nvidia-settings nvidia-smi; do
            cp $i $out/bin/$i
            patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                --set-rpath $out/lib:$programPath:$glPath $out/bin/$i
        done

        patchelf --set-rpath $glPath:$gtkPath $out/lib/libnvidia-gtk2.so.*.*

        # Test a bit.
        $out/bin/nvidia-settings --version
    else
        rm $out/lib/libnvidia-gtk2.*
    fi

    # For simplicity and dependency reduction, don't support the gtk3 interface.
    rm $out/lib/libnvidia-gtk3.*

    # Move VDPAU libraries to their place
    mkdir "$out"/lib/vdpau
    mv "$out"/lib/libvdpau* "$out"/lib/vdpau
}


genericBuild
