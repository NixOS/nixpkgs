{ stdenv, lib, fetchgit, cmake, writeScriptBin, callPackage
, perl, XMLLibXML, XMLLibXSLT, zlib
, enableStoneSense ? false,  allegro5, mesa
}:

let
  dfVersion = "0.44.05";
  version = "${dfVersion}-r2";
  rev = "refs/tags/${version}";
  sha256 = "1hr3qsx7rd36syw7dfp4lh8kpmz1pvva757za2yn34hj1jm4nh52";

  # revision of library/xml submodule
  xmlRev = "2794f8a6d7405d4858bac486a0bb17b94740c142";

  arch =
    if stdenv.system == "x86_64-linux" then "64"
    else if stdenv.system == "i686-linux" then "32"
    else throw "Unsupported architecture";

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell}
    if [ "$*" = "describe --tags --long" ]; then
      echo "${version}-unknown"
    elif [ "$*" = "rev-parse HEAD" ]; then
      if [ "$(dirname "$(pwd)")" = "xml" ]; then
        echo "${xmlRev}"
      else
        echo "${rev}"
      fi
    elif [ "$*" = "rev-parse HEAD:library/xml" ]; then
      echo "${xmlRev}"
    else
      exit 1
    fi
  '';

in stdenv.mkDerivation rec {
  name = "dfhack-${version}";

  # Beware of submodules
  src = fetchgit {
    url = "https://github.com/DFHack/dfhack";
    inherit rev sha256;
  };

  patches = [ ./fix-stonesense.patch ];

  nativeBuildInputs = [ cmake perl XMLLibXML XMLLibXSLT fakegit ];
  # We don't use system libraries because dfhack needs old C++ ABI.
  buildInputs = [ zlib ]
             ++ lib.optionals enableStoneSense [ allegro5 mesa ];

  preConfigure = ''
    # Trick build system into believing we have .git
    mkdir -p .git/modules/library/xml
    touch .git/index .git/modules/library/xml/index
  '';

  preBuild = ''
    export LD_LIBRARY_PATH="$PWD/depends/protobuf:$LD_LIBRARY_PATH"
  '';

  cmakeFlags = [ "-DDFHACK_BUILD_ARCH=${arch}" "-DDOWNLOAD_RUBY=OFF" ]
            ++ lib.optionals enableStoneSense [ "-DBUILD_STONESENSE=ON" "-DSTONESENSE_INTERNAL_SO=OFF" ];

  enableParallelBuilding = true;

  passthru = { inherit version dfVersion; };

  meta = with stdenv.lib; {
    description = "Memory hacking library for Dwarf Fortress and a set of tools that use it";
    homepage = https://github.com/DFHack/dfhack/;
    license = licenses.zlib;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ robbinch a1russell abbradar ];
  };
}
