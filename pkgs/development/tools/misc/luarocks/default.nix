{stdenv, fetchurl, lua, curl}:
let
  s = # Generated upstream information
  rec {
    baseName="luarocks";
    version="2.1.2";
    name="${baseName}-${version}";
    hash="1wwz71ymzjcyw8pz36yiw2x87c6v8nx5vdcd7zibm1n815v5qqk2";
    url="http://luarocks.org/releases/luarocks-2.1.2.tar.gz";
    sha256="1wwz71ymzjcyw8pz36yiw2x87c6v8nx5vdcd7zibm1n815v5qqk2";
  };
  buildInputs = [
    lua curl
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''A package manager for Lua'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
