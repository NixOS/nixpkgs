{ stdenv, fetchgit, cmake, writeScriptBin
, perl, XMLLibXML, XMLLibXSLT
, zlib
, jsoncpp, protobuf, tinyxml
}:

let
  rev = "5e2fc5662115499c10bfcd8a6105a1efe4de081c";
  xmlRev = "f371e293002f8f6d1e4704cc5869ca07ccf6c4d5";
  dfVersion = "0.42.06";

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell}
    if [ "$*" = "describe --tags --long" ]; then
      echo "${dfVersion}-unknown"
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
  version = "2016-03-03";

  # Beware of submodules
  src = fetchgit {
    url = "https://github.com/DFHack/dfhack";
    inherit rev;
    sha256 = "143zkx6hqpqxjhjd1bllg2kfia215x63zifkhgzycg49kw4wkxi5";
  };

  patches = [ ./use-system-libraries.patch ];

  nativeBuildInputs = [ cmake perl XMLLibXML XMLLibXSLT fakegit ];
  # we can't use native Lua; upstream uses private headers
  buildInputs = [ zlib jsoncpp protobuf tinyxml ];

  enableParallelBuilding = true;

  passthru = { inherit dfVersion; };

  meta = with stdenv.lib; {
    description = "Memory hacking library for Dwarf Fortress and a set of tools that use it";
    homepage = "https://github.com/DFHack/dfhack/";
    license = licenses.zlib;
    platforms = [ "i686-linux" ];
    maintainers = with maintainers; [ robbinch a1russell abbradar ];
  };
}
