{ stdenv, fetchgit, cmake, writeScriptBin
, perl, XMLLibXML, XMLLibXSLT
, zlib
}:

let
  dfVersion = "0.43.05";
  # version = "${dfVersion}-r1";
  # rev = "refs/tags/${version}";
  version = "${dfVersion}-alpha2";
  rev = "13eb5e702beb6d8e40c0e17be64cda9a8d9d1efb";
  sha256 = "18i8qfhhfnfrpa519akwagn73q2zns1pry2sdfag63vffxh60zr5";

  # revision of library/xml submodule
  xmlRev = "84f6e968a9ec5515f9dbef96b445e3fc83f83e8b";

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

  patches = [ ./skip-ruby.patch ];

  nativeBuildInputs = [ cmake perl XMLLibXML XMLLibXSLT fakegit ];
  # We don't use system libraries because dfhack needs old C++ ABI.
  buildInputs = [ zlib ];

  preBuild = ''
    export LD_LIBRARY_PATH="$PWD/depends/protobuf:$LD_LIBRARY_PATH"
  '';

  cmakeFlags = [ "-DDFHACK_BUILD_ARCH=${arch}" ];

  enableParallelBuilding = true;

  passthru = { inherit version dfVersion; };

  meta = with stdenv.lib; {
    description = "Memory hacking library for Dwarf Fortress and a set of tools that use it";
    homepage = "https://github.com/DFHack/dfhack/";
    license = licenses.zlib;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ robbinch a1russell abbradar ];
  };
}
