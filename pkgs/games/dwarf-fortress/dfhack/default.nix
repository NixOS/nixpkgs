{ stdenv, buildEnv, lib, fetchFromGitHub, cmake, writeScriptBin
, perl, XMLLibXML, XMLLibXSLT, zlib
, enableStoneSense ? false,  allegro5, libGLU_combined
, enableTWBT ? true, twbt
, SDL
}:

let
  dfVersion = "0.44.12";
  version = "${dfVersion}-r1";

  # revision of library/xml submodule
  xmlRev = "23500e4e9bd1885365d0a2ef1746c321c1dd5094";

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
        echo "refs/tags/${version}"
      fi
    elif [ "$*" = "rev-parse HEAD:library/xml" ]; then
      echo "${xmlRev}"
    else
      exit 1
    fi
  '';

  dfhack = stdenv.mkDerivation rec {
    name = "dfhack-base-${version}";

    # Beware of submodules
    src = fetchFromGitHub {
      owner = "DFHack";
      repo = "dfhack";
      sha256 = "0j03lq6j6w378z6cvm7jspxc7hhrqm8jaszlq0mzfvap0k13fgyy";
      rev = version;
      fetchSubmodules = true;
    };

    patches = [ ./fix-stonesense.patch ];
    nativeBuildInputs = [ cmake perl XMLLibXML XMLLibXSLT fakegit ];
    # We don't use system libraries because dfhack needs old C++ ABI.
    buildInputs = [ zlib SDL ]
               ++ lib.optionals enableStoneSense [ allegro5 libGLU_combined ];

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
  };
in

buildEnv {
  name = "dfhack-${version}";

  passthru = { inherit version dfVersion; };

  paths = [ dfhack ] ++ lib.optionals enableTWBT [ twbt.lib ];

  meta = with stdenv.lib; {
    description = "Memory hacking library for Dwarf Fortress and a set of tools that use it";
    homepage = https://github.com/DFHack/dfhack/;
    license = licenses.zlib;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ robbinch a1russell abbradar numinit ];
  };
}
