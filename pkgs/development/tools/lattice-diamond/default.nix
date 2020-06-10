{ stdenv, rpmextract, patchelf, makeWrapper, file, requireFile, glib, zlib, 
    freetype, fontconfig, xorg, libusb-compat-0_1, tcsh, coreutils, libuuid }:

stdenv.mkDerivation {
  name = "diamond-3.11-sp2";

  nativeBuildInputs = [ rpmextract patchelf makeWrapper file tcsh ];

  src = requireFile {
    name = "diamond_3_11-base_x64-396-4-x86_64-linux.rpm";
    url = "https://www.latticesemi.com/view_document?document_id=52662";
    sha256 = "1pik6w1qig28ri5klvy1if5gryin21iscz21vj3j7hfhbz4m8mka";
  };

  sp1 = requireFile {
    name = "diamond_3_11-sp1_x64-441-0-x86_64-linux.rpm";
    url = "https://www.latticesemi.com/view_document?document_id=52742";
    sha256 = "1basdw6xiz8lc1a1d1q5dvnpc5586p2mjhravyvchx9nnsqmcbhb";
  };

  sp2 = requireFile {
    name = "diamond_3_11-sp2_x64-446-3-x86_64-linux.rpm";
    url = "https://www.latticesemi.com/view_document?document_id=52844";
    sha256 = "1bqymza3kl1r2n0gippcd4zpcflcn6cpk2kdzliqkisrn8s45r9p";
  };

  buildCommand = ''
    origprefix=usr/local/diamond/3.11_x64
    prefix=diamond/3.11_x64

    pushd $(pwd)

    echo "Unpacking $src..."
    rpmextract $src
    
    # Move $pwd/usr/local/diamond/VERS to $out/diamond, cd.
    mkdir -p $out/$prefix
    rmdir $out/$prefix
    mv $origprefix $out/$prefix
    
    cd $out
    
    # Extract all tarballs.
    for tb in \
        cae_library/cae_library.tar.gz \
        embedded_source/embedded_source.tar.gz \
        ispfpga/ispfpga.tar.gz \
        synpbase/synpbase.tar.gz \
        tcltk/tcltk.tar.gz \
        bin/bin.tar.gz \
        examples/examples.tar.gz \
        data/data.tar.gz ; do
    
        echo "Extracting tarball $prefix/$tb"
        cd $out/$prefix/$(dirname $tb)
        tar xf $(basename $tb)
        rm $(basename $tb)
    done

    popd

    for sp in $sp1 $sp2 ; do
        echo "Unpacking $sp..."
        rpmextract $sp
        substituteInPlace $origprefix/sp/cp_pack --replace "/bin/csh" "${tcsh}/bin/tcsh"
        substituteInPlace $origprefix/sp/cp_pack --replace rpm echo
        substituteInPlace $origprefix/sp/cp_pack --replace '"$temp" == "$temp1"' '"1" == "0"'
        mv $origprefix/* $out/$prefix
        $out/$prefix/sp/cp_pack 3.11 $out $out
        rm -rf $out/$prefix/sp
    done

    # Patch shebangs in start scripts .
    cd $out/$prefix/bin/lin64
    for tool in \
        programmer \
        pgrcmd \
        diamond_env \
        powercal \
        model300 \
        update \
        diamond \
        debugger \
        ddtcmd \
        cableserver \
        revealrva \
        ipexpress \
        fileutility \
        diamond ; do
        
        echo "Patching script $prefix/bin/lin64/$tool..."
        patchShebangs $tool
    done

    substituteInPlace $out/$prefix/synpbase/bin/config/platform_set --replace "/usr/bin/id" "${coreutils}/bin/id"

    # Patch executable ELFs.
    for path in bin/lin64 ispfpga/bin/lin64 synpbase/linux_a_64/mbin; do
        cd $out/$prefix/$path
        for f in *; do
            if ! file $f | grep -q "ELF 64-bit LSB executable" ; then
                continue
            fi
            echo "Patching ELF $prefix/$path/$f..."
            # We force RPATH otherwise libraries from LD_LIBRARY_PATH (which the
            # tools mangle by themselves) will not be able to find their
            # dependencies from nix.
            patchelf \
                --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                --set-rpath "$libPath" --force-rpath \
                $f
        done
    done
    
    # Remove 32-bit libz.
    rm $out/$prefix/bin/lin64/libz.{so,so.1}
    rm $out/$prefix/bin/lin64/libstdc++.so.{6,6.0.18}
    
    # Make wrappers (should these target more than the 'diamond' tool?).
    # The purpose of these is just to call the target program using its
    # absolute path - otherwise, it will crash.
    mkdir -p bin
    for tool in diamond ; do
        makeWrapper $out/$prefix/bin/lin64/$tool $out/bin/$tool
    done
  '';

  libPath = stdenv.lib.makeLibraryPath [
    glib zlib freetype fontconfig
    xorg.libSM xorg.libICE xorg.libXrender xorg.libXext xorg.libX11 xorg.libXt xorg.libXScrnSaver
    libusb-compat-0_1 stdenv.cc.cc.lib libuuid
  ];

  meta = {
    description = "Vendor development tools for Lattice FPGA devices";
    longDescription = ''
      Lattice Diamond software is the leading-edge software design environment
      for cost- sensitive, low-power Lattice FPGA architectures. It is the
      next-generation replacement for ispLEVER.
    '';
    homepage = "http://www.latticesemi.com/latticediamond";
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ q3k ];
    platforms = [ "x86_64-linux" ];
  };
}
