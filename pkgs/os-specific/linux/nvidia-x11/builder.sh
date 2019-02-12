source $stdenv/setup

unpackManually() {
    skip=$(sed 's/^skip=//; t; d' $src)
    tail -n +$skip $src | xz -d | tar xvf -
    sourceRoot=.
}


unpackFile() {
    sh $src -x || unpackManually
}


buildPhase() {
    if [ -n "$bin" ]; then
        # Create the module.
        echo "Building linux driver against kernel: $kernel";
        cd kernel
        sysSrc=$(echo $kernel/lib/modules/$kernelVersion/source)
        sysOut=$(echo $kernel/lib/modules/$kernelVersion/build)
        unset src # used by the nv makefile
        make SYSSRC=$sysSrc SYSOUT=$sysOut module -j$NIX_BUILD_CORES

        cd ..
    fi
}


installPhase() {
    # Install libGL and friends.

    # since version 391, 32bit libraries are bundled in the 32/ sub-directory
    if [ "$i686bundled" = "1" ]; then
        mkdir -p "$lib32/lib"
        cp -prd 32/*.so.* "$lib32/lib/"
        if [ -d 32/tls ]; then
            cp -prd 32/tls "$lib32/lib/"
        fi
    fi

    mkdir -p "$out/lib"
    cp -prd *.so.* "$out/lib/"
    if [ -d tls ]; then
        cp -prd tls "$out/lib/"
    fi

    for i in $lib32 $out; do
        rm -f $i/lib/lib{glx,nvidia-wfb}.so.* # handled separately
        rm -f $i/lib/libnvidia-gtk* # built from source
        if [ "$useGLVND" = "1" ]; then
            # Pre-built libglvnd
            rm $i/lib/lib{GL,GLX,EGL,GLESv1_CM,GLESv2,OpenGL,GLdispatch}.so.*
        fi
        # Use ocl-icd instead
        rm -f $i/lib/libOpenCL.so*
        # Move VDPAU libraries to their place
        mkdir $i/lib/vdpau
        mv $i/lib/libvdpau* $i/lib/vdpau

        # Install ICDs.
        install -Dm644 nvidia.icd $i/etc/OpenCL/vendors/nvidia.icd
        if [ -e nvidia_icd.json.template ]; then
            sed "s#__NV_VK_ICD__#libGLX_nvidia.so#" nvidia_icd.json.template > nvidia_icd.json
            install -Dm644 nvidia_icd.json $i/share/vulkan/icd.d/nvidia.json
        fi
        if [ "$useGLVND" = "1" ]; then
            install -Dm644 10_nvidia.json $i/share/glvnd/egl_vendor.d/nvidia.json
        fi

    done


    if [ -n "$bin" ]; then
        # Install the X drivers.
        mkdir -p $bin/lib/xorg/modules
        cp -p libnvidia-wfb.* $bin/lib/xorg/modules/
        mkdir -p $bin/lib/xorg/modules/drivers
        cp -p nvidia_drv.so $bin/lib/xorg/modules/drivers
        mkdir -p $bin/lib/xorg/modules/extensions
        cp -p libglx*.so* $bin/lib/xorg/modules/extensions

        # Install the kernel module.
        mkdir -p $bin/lib/modules/$kernelVersion/misc
        for i in $(find ./kernel -name '*.ko'); do
            nuke-refs $i
            cp $i $bin/lib/modules/$kernelVersion/misc/
        done

        # Install application profiles.
        if [ "$useProfiles" = "1" ]; then
            mkdir -p $bin/share/nvidia
            cp nvidia-application-profiles-*-rc $bin/share/nvidia/nvidia-application-profiles-rc
            cp nvidia-application-profiles-*-key-documentation $bin/share/nvidia/nvidia-application-profiles-key-documentation
        fi
    fi

    # All libs except GUI-only are installed now, so fixup them.
    for libname in $(find "$out/lib/" $(test -n "$lib32" && echo "$lib32/lib/") $(test -n "$bin" && echo "$bin/lib/") -name '*.so.*')
    do
      # I'm lazy to differentiate needed libs per-library, as the closure is the same.
      # Unfortunately --shrink-rpath would strip too much.
      patchelf --set-rpath "$out/lib:$libPath" "$libname"

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

    if [ -n "$bin" ]; then
        # Install /share files.
        mkdir -p $bin/share/man/man1
        cp -p *.1.gz $bin/share/man/man1
        rm -f $bin/share/man/man1/{nvidia-xconfig,nvidia-settings,nvidia-persistenced}.1.gz

        # Install the programs.
        for i in nvidia-cuda-mps-control nvidia-cuda-mps-server nvidia-smi nvidia-debugdump; do
            if [ -e "$i" ]; then
                install -Dm755 $i $bin/bin/$i
                patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                    --set-rpath $out/lib:$libPath $bin/bin/$i
            fi
        done
        # FIXME: needs PATH and other fixes
        # install -Dm755 nvidia-bug-report.sh $bin/bin/nvidia-bug-report.sh
    fi
}


genericBuild
