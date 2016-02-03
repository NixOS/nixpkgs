source $stdenv/setup

dontPatchELF=1 # must keep libXv, $out in RPATH


unpackFile() {
    sh $src -x
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
        make SYSSRC=$sysSrc SYSOUT=$sysOut module
        cd ..
    fi
}


installPhase() {

    # Install libGL and friends.
    mkdir -p $out/lib/vendors

    for f in \
      libcuda libGL libnvcuvid libnvidia-cfg libnvidia-compiler \
      libnvidia-glcore libnvidia-ml libnvidia-opencl \
      libnvidia-tls libOpenCL libnvidia-tls libvdpau_nvidia
    do
      cp -prd $f.* $out/lib/
      ln -snf $f.so.$versionNumber $out/lib/$f.so
      ln -snf $f.so.$versionNumber $out/lib/$f.so.1
    done

    cp -p nvidia.icd $out/lib/vendors/
    cp -prd tls $out/lib/
    cp -prd libOpenCL.so.1.0.0 $out/lib/
    ln -snf libOpenCL.so.1.0.0 $out/lib/libOpenCL.so
    ln -snf libOpenCL.so.1.0.0 $out/lib/libOpenCL.so.1

    patchelf --set-rpath $out/lib:$glPath $out/lib/libGL.so.*.*
    patchelf --set-rpath $out/lib:$glPath $out/lib/libvdpau_nvidia.so.*.*
    patchelf --set-rpath $cudaPath $out/lib/libcuda.so.*.*

    if test -z "$libsOnly"; then

        # Install the kernel module.
        mkdir -p $out/lib/modules/$kernelVersion/misc
        cp kernel/nvidia.ko $out/lib/modules/$kernelVersion/misc

        # Install the X driver.
        mkdir -p $out/lib/xorg/modules
        cp -p libnvidia-wfb.* $out/lib/xorg/modules/
        mkdir -p $out/lib/xorg/modules/drivers
        cp -p nvidia_drv.so $out/lib/xorg/modules/drivers
        mkdir -p $out/lib/xorg/modules/extensions
        cp -p libglx.so.* $out/lib/xorg/modules/extensions

        ln -snf libnvidia-wfb.so.$versionNumber $out/lib/xorg/modules/libnvidia-wfb.so.1
        ln -snf libglx.so.$versionNumber $out/lib/xorg/modules/extensions/libglx.so

        patchelf --set-rpath $out/lib $out/lib/xorg/modules/extensions/libglx.so.*.*

        # Install the programs.
        mkdir -p $out/bin

        for i in nvidia-settings nvidia-xconfig; do
	    cp $i $out/bin/$i
	    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
	        --set-rpath $out/lib:$programPath:$glPath $out/bin/$i
        done

        # Header files etc.
        mkdir -p $out/include/nvidia
        cp -p *.h $out/include/nvidia

        mkdir -p $out/share/man/man1
        cp -p *.1.gz $out/share/man/man1

        mkdir -p $out/share/applications
        cp -p *.desktop $out/share/applications

        mkdir -p $out/share/pixmaps
        cp -p nvidia-settings.png $out/share/pixmaps

        # Patch the `nvidia-settings.desktop' file.
        substituteInPlace $out/share/applications/nvidia-settings.desktop \
            --replace '__UTILS_PATH__' $out/bin \
            --replace '__PIXMAP_PATH__' $out/share/pixmaps

        # Move VDPAU libraries to their place
        mkdir "$out"/lib/vdpau
        mv "$out"/lib/libvdpau* "$out"/lib/vdpau
    fi
}


genericBuild
