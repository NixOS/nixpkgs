source $stdenv/setup


configurePhase=configurePhase
configurePhase() {

        #hashname=$(basename $out)
        #if echo "$hashname" | grep -q '^[a-z0-9]\{32\}-'; then
        #  hashname=$(echo "$hashname" | cut -c -32)
        #fi

        #extraname=$(grep ^EXTRAVERSION Makefile)
        #perl -p -i -e "s/^EXTRAVERSION.*/$extraname-$hashname/" Makefile
        
	export INSTALL_PATH=$out
	export INSTALL_MOD_PATH=$out

	cp $config .config
        make oldconfig
}


buildPhase=buildPhase
buildPhase() {
	make
}


installPhase=installPhase
installPhase() {

	ensureDir $out
        
	make install

        export MODULE_DIR=$out/lib/modules
	make modules_install DEPMOD=$module_init_tools/sbin/depmod

        # Strip the kernel modules.
        echo "Stripping kernel modules..."
        find $out -name "*.ko" -print0 | xargs -0 strip -S

        # move this to install later on
        # largely copied from early FC3 kernel spec files
        version=$(cd $out/lib/modules && ls -d *)

        # remove symlinks and create directories
        rm -f $out/lib/modules/$version/build
        rm -f $out/lib/modules/$version/source
        mkdir $out/lib/modules/$version/build
        ln -s $out/lib/modules/$version/build $out/lib/modules/$version/source
        # copy all Makefiles and Kconfig files
        cp --parents `find  -type f -name Makefile -o -name "Kconfig*"` $out/lib/modules/$version/build
        cp Module.symvers $out/lib/modules/$version/build

        # weed out unneeded stuff
        rm -rf $out/lib/modules/$version/build/Documentation
        rm -rf $out/lib/modules/$version/build/scripts
        rm -rf $out/lib/modules/$version/build/include

        # copy config
	cp .config $out/lib/modules/$version/build/.config

        # copy architecture dependent files

        cp -a arch/$arch/scripts $out/lib/modules/$version/build || true
        cp -a arch/$arch/*lds $out/lib/modules/$version/build || true
        cp -a arch/$arch/Makefile.cpu $out/lib/modules/$version/build/arch/$arch || true
        cp -a --parents arch/$arch/kernel/asm-offsets.s $out/lib/modules/$version/build/arch/$arch/kernel || true

        # copy scripts
        rm -f scripts/*.o
        rm -f scripts/*/*.o
        cp -a scripts $out/lib/modules/$version/build

        # copy include files
        mkdir -p $out/lib/modules/$version/build/include
        cd include
        cp -a acpi config linux math-emu media net pcmcia rxrpc scsi sound video asm asm-generic $out/lib/modules/$version/build/include
        cp -a `readlink asm` $out/lib/modules/$version/build/include
        cd ..
}


genericBuild
