source $stdenv/setup

dontPatchELF=1 # must keep libXv, $out in RPATH


unpackFile() {
    sh $src -x
}


buildPhase() {
    if test -z "$libsOnly"; then
        echo "Building linux driver against kernel: " $kernel;

        cd usr/src/nv/

        # Workaround: get it to build on kernels that have CONFIG_XEN
        # set.  Disable the test, apply a patch to disable the Xen
        # functionality.
        
        #substituteInPlace Makefile.kbuild --replace xen_sanity_check fnord
        #patch -p1 < $xenPatch

        # Create the module.
        kernelVersion=$(cd $kernel/lib/modules && ls)
        sysSrc=$(echo $kernel/lib/modules/$kernelVersion/build/)
        unset src # used by the nv makefile
        # Hack necessary to compile on 2.6.28.
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$sysSrc/include/asm/mach-default"
        make SYSSRC=$sysSrc module
        cd ../../..
    fi
}


installPhase() {

    # Install libGL and friends.
    ensureDir $out/lib
    cp -prd usr/lib/* usr/X11R6/lib/libXv* $out/lib/

    ln -snf libGLcore.so.$versionNumber $out/lib/libGLcore.so
    ln -snf libGLcore.so.$versionNumber $out/lib/libGLcore.so.1
    ln -snf libGL.so.$versionNumber $out/lib/libGL.so
    ln -snf libGL.so.$versionNumber $out/lib/libGL.so.1
    ln -snf libnvidia-cfg.so.$versionNumber $out/lib/libnvidia-cfg.so.1
    ln -snf libnvidia-tls.so.$versionNumber $out/lib/libnvidia-tls.so.1
    ln -snf libnvidia-tls.so.$versionNumber $out/lib/tls/libnvidia-tls.so.1
    ln -snf libXvMCNVIDIA.so.$versionNumber $out/lib/libXvMCNVIDIA_dynamic.so.1
    ln -snf libcuda.so.$versionNumber $out/lib/libcuda.so.1

    patchelf --set-rpath $out/lib:$glPath $out/lib/libGL.so.*.*
    patchelf --set-rpath $out/lib:$glPath $out/lib/libXvMCNVIDIA.so.*.*
    set +e
    # Legacy nvidia doesn't have cuda
    patchelf --set-rpath $cudaPath $out/lib/libcuda.so.*.*
    set -e
    
    if test -z "$libsOnly"; then
        
        # Install the kernel module.
        ensureDir $out/lib/modules/$kernelVersion/misc
        cp usr/src/nv/nvidia.ko $out/lib/modules/$kernelVersion/misc

        # Install the X driver.
        ensureDir $out/lib/xorg/modules
        cp -prd usr/X11R6/lib/modules/* $out/lib/xorg/modules/

        ln -snf libnvidia-wfb.so.$versionNumber $out/lib/xorg/modules/libnvidia-wfb.so.1
        ln -snf libglx.so.$versionNumber $out/lib/xorg/modules/extensions/libglx.so

        patchelf --set-rpath $out/lib $out/lib/xorg/modules/extensions/libglx.so.*.*

        # Install the programs.
        ensureDir $out/bin

        for i in nvidia-settings nvidia-xconfig; do
	    cp usr/bin/$i $out/bin/$i
	    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
	        --set-rpath $out/lib:$programPath:$glPath $out/bin/$i
        done
    
        # Header files etc.
        cp -prd usr/include usr/share $out

        # Patch the `nvidia-settings.desktop' file.
        substituteInPlace $out/share/applications/nvidia-settings.desktop \
            --replace '__UTILS_PATH__' $out/bin \
            --replace '__PIXMAP_PATH__' $out/share/pixmaps
    fi
}


genericBuild
