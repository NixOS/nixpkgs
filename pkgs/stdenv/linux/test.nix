{system ? builtins.currentSystem}:

with import ../../top-level/all-packages.nix {inherit system;};

rec {


  # We want coreutils without ACL support.
  coreutils_ = coreutils.function (args: {
    aclSupport = false;
  });

  
  build = 

    stdenv.mkDerivation {
      name = "build";

      buildInputs = [nukeReferences];

      buildCommand = ''
        ensureDir $out/bin $out/lib $out/libexec

        # Copy what we need of Glibc.
        cp -d ${glibc}/lib/ld-*.so* $out/lib
        cp -d ${glibc}/lib/libc*.so* $out/lib
        cp -d ${glibc}/lib/libc_nonshared.a $out/lib
        cp -d ${glibc}/lib/libm*.so* $out/lib
        cp -d ${glibc}/lib/libdl*.so* $out/lib
        cp -d ${glibc}/lib/librt*.so*  $out/lib
        cp -d ${glibc}/lib/libpthread*.so* $out/lib
        cp -d ${glibc}/lib/libnsl*.so* $out/lib
        cp -d ${glibc}/lib/libutil*.so* $out/lib
        cp -d ${glibc}/lib/crt?.o $out/lib
        
        cp -rL ${glibc}/include $out
        chmod -R u+w $out/include
        
        # Hopefully we won't need these.
        rm -rf $out/include/mtd $out/include/rdma $out/include/sound $out/include/video
        
        # Copy coreutils, bash, etc.
        cp ${coreutils_}/bin/* $out/bin
        (cd $out/bin && rm vdir dir sha*sum pinky factor pathchk runcon shuf who whoami shred users)
        
        cp ${bash}/bin/bash $out/bin
        cp ${findutils}/bin/find $out/bin
        cp ${findutils}/bin/xargs $out/bin
        cp -d ${diffutils}/bin/* $out/bin
        cp -d ${gnused}/bin/* $out/bin
        cp -d ${gnugrep}/bin/* $out/bin
        cp ${gawk}/bin/gawk $out/bin
        cp -d ${gawk}/bin/awk $out/bin
        cp ${gnutar}/bin/tar $out/bin
        cp ${gzip}/bin/gzip $out/bin
        cp ${bzip2}/bin/bzip2 $out/bin
        cp -d ${gnumake}/bin/* $out/bin
        cp -d ${patch}/bin/* $out/bin
        cp ${patchelf}/bin/* $out/bin
        cp ${replace}/bin/* $out/bin

        cp -d ${gnugrep.pcre}/lib/libpcre*.so* $out/lib # needed by grep
        
        # Copy what we need of gcc.    
        cp -d ${gcc.gcc}/bin/gcc $out/bin
        cp -d ${gcc.gcc}/bin/cpp $out/bin
        cp -d ${gcc.gcc}/bin/g++ $out/bin
        cp -d ${gcc.gcc}/lib/libgcc_s.so* $out/lib
        cp -d ${gcc.gcc}/lib/libstdc++.so* $out/lib
        cp -rd ${gcc.gcc}/lib/gcc $out/lib
        chmod -R u+w $out/lib
        rm -f $out/lib/gcc/*/*/include/linux
        rm -f $out/lib/gcc/*/*/include/sound
        cp -rd ${gcc.gcc}/libexec/* $out/libexec
        cp -rd ${gcc.gcc}/include/c++ $out/include

        # Copy binutils.
        for i in as ld ar ranlib nm strip readelf objdump; do
          cp ${binutils}/bin/$i $out/bin
        done

        # Copy perl.
        cp ${perl}/bin/perl $out/bin
        
        chmod -R u+w $out
        
        # Strip executables even further.
        for i in $out/bin/* $out/libexec/gcc/*/*/*; do
            if test -x $i -a ! -L $i; then
                chmod +w $i
                strip -s $i || true
            fi
        done
        
        nuke-refs $out/bin/*
        nuke-refs $out/lib/*
        nuke-refs $out/libexec/gcc/*/*/*

        (cd $out && tar cvfj $out/static-tools.tar.bz2 bin lib libexec include)
      ''; # */

      # The result should not contain any references (store paths) so
      # that we can safely copy them out of the store and to other
      # locations in the store.
      allowedReferences = [];
    };

  
  unpack =
    
    stdenv.mkDerivation {
      name = "unpack";

      buildCommand = ''
        tar xvfj ${build}/static-tools.tar.bz2
        cp -prd . $out
        rm $out/env-vars

        for i in $out/bin/* $out/libexec/gcc/*/*/*; do
            echo patching $i
            if ! test -L $i; then
                LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux.so.2 \
                    $out/bin/patchelf --set-interpreter $out/lib/ld-linux.so.2 --set-rpath $out/lib $i
            fi
        done

        # Fix the libc linker script.
        for i in $out/lib/libc.so; do
            cat $i | sed "s|/nix/store/e*-[^/]*/|$out/|g" > $i.tmp
            mv $i.tmp $i
        done
      ''; # */

      allowedReferences = ["out"];
    };


  test =

    stdenv.mkDerivation {
      name = "test";

      LD_LIBRARY_PATH = "${unpack}/lib";

      realBuilder = "${unpack}/bin/bash";
      
      buildCommand = ''
        export PATH=${unpack}/bin
        ls -l
        mkdir $out
        mkdir $out/bin
        sed --version
        find --version
        diff --version
        patch --version
        make --version
        awk --version
        grep --version
        gcc --version

        perl -e 'print 1 + 2, "\n";'

        export CPP="cpp -B${unpack}"
        export CC="gcc -B${unpack} -Wl,-dynamic-linker,${unpack}/lib/ld-linux.so.2 -Wl,-rpath,${unpack}/lib"
        export CXX="g++ -B${unpack} -Wl,-dynamic-linker,${unpack}/lib/ld-linux.so.2 -Wl,-rpath,${unpack}/lib"
        
        echo '#include <stdio.h>' >> foo.c
        echo 'int main() { printf("Hello World\n"); return 0; }' >> foo.c
        $CC -o $out/bin/foo foo.c
        $out/bin/foo

        echo '#include <iostream>' >> bar.cc
        echo 'int main() { std::cout << "Hello World\n"; }' >> bar.cc
        $CXX -o $out/bin/bar bar.cc
        $out/bin/bar

        tar xvf ${hello.src}
        cd hello-*
        ./configure --prefix=$out
        make
        make install
      ''; # */
    };
    
}
