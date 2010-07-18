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
        sysSrc=$(echo $kernel/lib/modules/$kernelVersion/build/)
        unset src # used by the nv makefile
        # Hack necessary to compile on 2.6.28.
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$sysSrc/include/asm/mach-default"
        make SYSSRC=$sysSrc module
        cd ..
    fi
}


installPhase() {

    # Install libGL and friends.
    ensureDir $out/lib
    cp -prd libcuda.* libGL.* libnvidia-cfg.* libnvidia-compiler.* libnvidia-tls.* libnvidia-glcore.* libOpenCL.* libvdpau.* libXv* tls $out/lib/
    ensureDir $out/lib/vdpau
    cp -p libvdpau_* $out/lib/vdpau
    
    ln -snf libnvidia-glcore.so.$versionNumber $out/lib/libnvidia-glcore.so
    ln -snf libnvidia-glcore.so.$versionNumber $out/lib/libnvidia-glcore.so.1
    ln -snf libGL.so.$versionNumber $out/lib/libGL.so
    ln -snf libGL.so.$versionNumber $out/lib/libGL.so.1
    ln -snf libnvidia-cfg.so.$versionNumber $out/lib/libnvidia-cfg.so.1
    ln -snf libnvidia-tls.so.$versionNumber $out/lib/libnvidia-tls.so.1
    ln -snf libnvidia-tls.so.$versionNumber $out/lib/tls/libnvidia-tls.so.1
    ln -snf libXvMCNVIDIA.so.$versionNumber $out/lib/libXvMCNVIDIA_dynamic.so.1
    ln -snf libcuda.so.$versionNumber $out/lib/libcuda.so.1

    patchelf --set-rpath $out/lib:$glPath $out/lib/libGL.so.*.*
    patchelf --set-rpath $out/lib:$glPath $out/lib/libXvMCNVIDIA.so.*.*
    patchelf --set-rpath $cudaPath $out/lib/libcuda.so.*.*
    
    if test -z "$libsOnly"; then
        
        # Install the kernel module.
        ensureDir $out/lib/modules/$kernelVersion/misc
        cp kernel/nvidia.ko $out/lib/modules/$kernelVersion/misc

        # Install the X driver.
        ensureDir $out/lib/xorg/modules
        cp -p libnvidia-wfb.* $out/lib/xorg/modules/
        ensureDir $out/lib/xorg/modules/drivers
        cp -p nvidia_drv.so $out/lib/xorg/modules/drivers
        ensureDir $out/lib/xorg/modules/extensions
        cp -p libglx.so.* $out/lib/xorg/modules/extensions

        ln -snf libnvidia-wfb.so.$versionNumber $out/lib/xorg/modules/libnvidia-wfb.so.1
        ln -snf libglx.so.$versionNumber $out/lib/xorg/modules/extensions/libglx.so

        patchelf --set-rpath $out/lib $out/lib/xorg/modules/extensions/libglx.so.*.*

        # Install the programs.
        ensureDir $out/bin

        for i in nvidia-settings nvidia-xconfig; do
	    cp $i $out/bin/$i
	    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
	        --set-rpath $out/lib:$programPath:$glPath $out/bin/$i
        done
    
        # Header files etc.
        ensureDir $out/include/nvidia
        cp -p *.h $out/include/nvidia

        ensureDir $out/share/man/man1
        cp -p *.1.gz $out/share/man/man1

        ensureDir $out/share/applications
        cp -p *.desktop $out/share/applications

        ensureDir $out/share/pixmaps
        cp -p nvidia-settings.png $out/share/pixmaps

        # Patch the `nvidia-settings.desktop' file.
        substituteInPlace $out/share/applications/nvidia-settings.desktop \
            --replace '__UTILS_PATH__' $out/bin \
            --replace '__PIXMAP_PATH__' $out/share/pixmaps
    fi
}


genericBuild
