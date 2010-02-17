source $stdenv/setup


makeFlags="ARCH=$arch SHELL=/bin/sh"
if [ -n "$crossConfig" ]; then
  makeFlags="$makeFlags CROSS_COMPILE=$crossConfig-"
fi

configurePhase() {
    if test -n "$preConfigure"; then 
        eval "$preConfigure"; 
    fi

    export INSTALL_PATH=$out
    export INSTALL_MOD_PATH=$out


    # Set our own localversion, if specified.
    rm -f localversion*
    if test -n "$localVersion"; then
        echo "$localVersion" > localversion-nix
    fi


    # Patch kconfig to print "###" after every question so that
    # generate-config.pl can answer them.
    sed -e '/fflush(stdout);/i\printf("###");' -i scripts/kconfig/conf.c

    # Get a basic config file for later refinement with $generateConfig.
    make $kernelBaseConfig ARCH=$arch

    # Create the config file.
    echo "generating kernel configuration..."
    echo "$kernelConfig" > kernel-config
    DEBUG=1 ARCH=$arch KERNEL_CONFIG=kernel-config AUTO_MODULES=$autoModules \
        perl -w $generateConfig
}


postBuild() {
    # After the builder did a 'make all' (kernel + modules)
    # we force building the target asked: bzImage/zImage/uImage/...
    make $makeFlags $kernelTarget
}

installPhase() {

    ensureDir $out

    # New kernel versions have a combined tree for i386 and x86_64.
    archDir=$arch
    if test -e arch/x86 -a \( "$arch" = i386 -o "$arch" = x86_64 \); then
        archDir=x86
    fi


    # Copy the bzImage and System.map.
    cp System.map $out
    if test "$arch" = um; then
        ensureDir $out/bin
        cp linux $out/bin
    else
        cp arch/$archDir/boot/$kernelTarget $out
    fi

    cp vmlinux $out

    # Install the modules in $out/lib/modules with matching paths
    # in modules.dep (i.e., refererring to $out/lib/modules, not
    # /lib/modules).  The depmod_opts= is to prevent the kernel
    # from passing `-b PATH' to depmod.
    export MODULE_DIR=$out/lib/modules/
    substituteInPlace Makefile --replace '-b $(INSTALL_MOD_PATH)' ''
    make modules_install \
        DEPMOD=$module_init_tools/sbin/depmod depmod_opts= \
        $makeFlags "${makeFlagsArray[@]}" \
        $installFlags "${installFlagsArray[@]}"

    # Strip the kernel modules.
    echo "Stripping kernel modules..."
    find $out -name "*.ko" -print0 | xargs -0 $crossConfig-strip -S

    # move this to install later on
    # largely copied from early FC3 kernel spec files
    version=$(cd $out/lib/modules && ls -d *)

    # remove symlinks and create directories
    rm -f $out/lib/modules/$version/build
    rm -f $out/lib/modules/$version/source
    mkdir $out/lib/modules/$version/build

    # copy config
    cp .config $out/lib/modules/$version/build/.config
    ln -s $out/lib/modules/$version/build/.config $out/config

    if test "$arch" != um; then
        # copy all Makefiles and Kconfig files
        ln -s $out/lib/modules/$version/build $out/lib/modules/$version/source
        cp --parents `find  -type f -name Makefile -o -name "Kconfig*"` $out/lib/modules/$version/build
        cp Module.symvers $out/lib/modules/$version/build

        # weed out unneeded stuff
        rm -rf $out/lib/modules/$version/build/Documentation
        rm -rf $out/lib/modules/$version/build/scripts
        rm -rf $out/lib/modules/$version/build/include

        # copy architecture dependent files
        cp -a arch/$archDir/scripts $out/lib/modules/$version/build/ || true
        cp -a arch/$archDir/*lds $out/lib/modules/$version/build/ || true
        cp -a arch/$archDir/Makefile*.cpu $out/lib/modules/$version/build/arch/$archDir/ || true
        cp -a --parents arch/$archDir/kernel/asm-offsets.s $out/lib/modules/$version/build/arch/$archDir/kernel/ || true

        # copy scripts
        rm -f scripts/*.o
        rm -f scripts/*/*.o
        cp -a scripts $out/lib/modules/$version/build

        # copy include files
        includeDir=$out/lib/modules/$version/build/include
        mkdir -p $includeDir
        (cd include && cp -a * $includeDir)
	(cd arch/$archDir/include && cp -a * $includeDir || true)
	(cd arch/$archDir/include && cp -a asm/* $includeDir/asm/ || true)
	(cd arch/$archDir/include/asm/mach-generic && cp -a * $includeDir/ || true)
    fi
}


genericBuild
