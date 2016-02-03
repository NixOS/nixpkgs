{ stdenv, fetchgit, cmake, writeScriptBin
, perl, XMLLibXML, XMLLibXSLT
, zlib
, jsoncpp, protobuf, tinyxml
}:

let
  rev = "f61ff9147e00f3c379ac0458e79eb556a5de1b68";
  dfVersion = "0.42.05";

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell}
    if [ "$*" = "describe --tags --long" ]; then
      echo "${dfVersion}-unknown"
    elif [ "$*" = "rev-parse HEAD" ]; then
      echo "${rev}"
    else
      exit 1
    fi
  '';

in stdenv.mkDerivation {
  name = "dfhack-20160118";

  # Beware of submodules
  src = fetchgit {
    url = "https://github.com/DFHack/dfhack";
    inherit rev;
    sha256 = "1ah3cplp4mb9pq7rm1cmn8klfjxw3y2xfzy7734i81b3iwiwlpi4";
  };

  patches = [ ./use-system-libraries.patch ];

  nativeBuildInputs = [ cmake perl XMLLibXML XMLLibXSLT fakegit ];
  # we can't use native Lua; upstream uses private headers
  buildInputs = [ zlib jsoncpp protobuf tinyxml ];

  enableParallelBuilding = true;

  passthru = { inherit dfVersion; };

  meta = with stdenv.lib; {
    description = "Memory hacking library for Dwarf Fortress and a set of tools that use it";
    homepage = https://github.com/DFHack/dfhack/;
    license = licenses.zlib;
    platforms = [ "i686-linux" ];
    maintainers = with maintainers; [ robbinch a1russell abbradar ];
  };
}
