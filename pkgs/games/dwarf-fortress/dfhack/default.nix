{ stdenv, fetchgit, cmake, writeScriptBin
, perl, XMLLibXML, XMLLibXSLT
, zlib
, jsoncpp, protobuf, tinyxml
}:

let
  dfVersion = "0.43.03";
  version = "${dfVersion}-r1";

  rev = "refs/tags/${version}";
  # revision of library/xml submodule
  xmlRev = "98cc1e01886aaea161d651cf97229ad08e9782b0";

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
    inherit rev;
    sha256 = "0m5kqpaz0ypji4c32w0hhbsicvgvnjh56pqvq7af6pqqnyg1nzcx";
  };

  patches = [ ./use-system-libraries.patch ];

  nativeBuildInputs = [ cmake perl XMLLibXML XMLLibXSLT fakegit ];
  # we can't use native Lua; upstream uses private headers
  buildInputs = [ zlib jsoncpp protobuf tinyxml ];

  cmakeFlags = [ "-DEXTERNAL_TINYXML=ON" ];

  enableParallelBuilding = true;

  passthru = { inherit version dfVersion; };

  meta = with stdenv.lib; {
    description = "Memory hacking library for Dwarf Fortress and a set of tools that use it";
    homepage = "https://github.com/DFHack/dfhack/";
    license = licenses.zlib;
    platforms = [ "i686-linux" ];
    maintainers = with maintainers; [ robbinch a1russell abbradar ];
  };
}
