{ stdenv, fetchgit, dwarf_fortress, cmake, zlib, perl, XMLLibXML, XMLLibXSLT
}:

let
  baseVersion = "40";
  patchVersion = "24-r3";
  src = fetchgit {
    url = "https://github.com/DFHack/dfhack.git";
    rev = "0849099f2083e100cae6f64940b4eff4c28ce2eb";
    sha256 = "0lnqrayi8hwfivkrxb7fw8lb6v95i04pskny1px7084n7nzvyv8b";
  };

in

assert stdenv.system == "i686-linux";
assert dwarf_fortress.name == "dwarf-fortress-0.40.24";

stdenv.mkDerivation rec {
  name = "dfhack-0.${baseVersion}.${patchVersion}";

  inherit baseVersion patchVersion src;

  buildInputs = [ cmake zlib perl XMLLibXML XMLLibXSLT ];

  preConfigure = ''
    export cmakeFlags="-DCMAKE_INSTALL_PREFIX=$prefix/dfhack $cmakeFlags"
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`/build/depends/protobuf
  '';

  installPhase = ''
    mkdir -p $out/dfhack
    make install
    cp ../package/linux/dfhack $out/dfhack/
    mkdir -p $out/bin
    cat > $out/bin/dfhack_install_dir <<EOF
    #!/bin/sh
    test -z "\$1" && echo "This creates a Dwarf Fortress/DFHack game directory. Please specify a directory (preferably empty or non-existent) for this." && exit 1

    set -e
    mkdir -p "\$1"
    cd "\$1"
    cp -r ${dwarf_fortress}/share/df_linux/* .
    cp -r $out/dfhack/* .
    chmod -R u+w .
    # use LD_LIBRARY_PATH setting from dwarf-fortress wrapper
    sed -e 's%# Now run%`grep LD_LIBRARY_PATH ${dwarf_fortress}/bin/dwarf-fortress`%' $out/dfhack/dfhack > dfhack
    # write md5sum of binary
    sed -e s/c42f55948a448645d6609102ef6439e8/`md5sum ${dwarf_fortress}/share/df_linux/libs/Dwarf_Fortress | cut -f1 -d\ `/ $out/dfhack/hack/symbols.xml > hack/symbols.xml

    echo "DFHack installed successfully in \$1. To play, run ./dfhack in it."

    EOF
    chmod +x $out/bin/dfhack_install_dir
  '';

  meta = {
    description = "A Dwarf Fortress memory access library";
    homepage = https://github.com/DFHack/dfhack;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ robbinch ];
  };
}
