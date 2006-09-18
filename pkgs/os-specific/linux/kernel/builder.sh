source $stdenv/setup


configurePhase=configurePhase
configurePhase() {
	cp $config .config
        #mkdir $out
        hashname=$(basename $out)
        if echo "$hashname" | grep -q '^[a-z0-9]\{32\}-'; then
          hashname=$(echo "$hashname" | cut -c -32)
        fi

        extraname=$(grep ^EXTRAVERSION Makefile)
        perl -p -i -e "s/^EXTRAVERSION.*/$extraname-$hashname/" Makefile
	export INSTALL_PATH=$out
	export INSTALL_MOD_PATH=$out

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

	make modules_install

        # Strip the kernel modules.
        echo "Stripping kernel modules..."
        find $out -name "*.ko" -print0 | xargs -0 strip -S

        # move this to install later on
        # largely copied from early FC3 kernel spec files
        stripHash $out
        version=$(echo $strippedName | cut -c 7-)-$hashname

        # remove symlinks and create directories
        rm $out/lib/modules/${version}/build
        rm $out/lib/modules/${version}/source
        mkdir $out/lib/modules/${version}/build
        ln -s $out/lib/modules/${version}/build $out/lib/modules/${version}/source
        # copy all Makefiles and Kconfig files
        cp --parents `find  -type f -name Makefile -o -name "Kconfig*"` $out/lib/modules/${version}/build
        cp Module.symvers $out/lib/modules/$version/build

        # weed out unneeded stuff
        rm -rf $out/lib/modules/$version/build/Documentation
        rm -rf $out/lib/modules/$version/build/scripts
        rm -rf $out/lib/modules/$version/build/include

        # copy config
	cp $config $out/lib/modules/${version}/build/.config

        # copy architecture dependent files

        cp -a arch/$arch/scripts $out/lib/modules/${version}/build || :
        cp -a arch/$arch/*lds $out/lib/modules/${version}/build || :
        cp -a arch/$arch/Makefile.cpu $out/lib/modules/${version}/build/arch/$arch || :
        cp -a --parents arch/$arch/kernel/asm-offsets.s $out/lib/modules/${version}/build/arch/$arch/kernel || :

        # copy scripts
        rm -rf scripts/*.o
        rm -rf scripts/*/.o
        cp -a scripts $out/lib/modules/${version}/build

        # copy include files
        mkdir -p $out/lib/modules/${version}/build/include
        cd include
        cp -a acpi config linux math-emu media net pcmcia rxrpc scsi sound video asm asm-generic $out/lib/modules/$version/build/include
        cp -a `readlink asm` $out/lib/modules/$version/build/include
        cd ..


        # Make sure the Makefile and version.h have a matching timestamp so that
        # external modules can be built
        touch -r $out/lib/modules/$version/build/Makefile $out/lib/modules/$version/build/include/linux/version.h
        touch -r $out/lib/modules/$version/build/.config $out/lib/modules/$version/build/include/linux/autoconf.h

}


genericBuild
