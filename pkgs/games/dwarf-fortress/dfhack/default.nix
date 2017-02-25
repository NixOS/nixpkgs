{ stdenv, fetchgit, cmake, writeScriptBin
, perl, XMLLibXML, XMLLibXSLT
, zlib
}:

let
  dfVersion = "0.43.05";
  # version = "${dfVersion}-r1";
  # rev = "refs/tags/${version}";
  version = "${dfVersion}-alpha4";
  rev = "refs/tags/${version}";
  sha256 = "0wnwdapw955k69ds5xh5qsh7h0l547wjxgcy8hkvly6wp5c16sls";

  # revision of library/xml submodule
  xmlRev = "bb4228f58b1601c4868c95be6763f5ff2e5d0a08";

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
