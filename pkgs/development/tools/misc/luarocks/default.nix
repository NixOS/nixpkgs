{stdenv, fetchurl, lua, curl}:
let
  s = # Generated upstream information
  rec {
    baseName="luarocks";
    version="2.1.1";
    name="${baseName}-${version}";
    hash="1b0qscmzdn80kxnn31v5q0rpafkwq1fr0766dzyh7dc2r6ws2nwr";
    url="http://luarocks.org/releases/luarocks-2.1.1.tar.gz";
    sha256="1b0qscmzdn80kxnn31v5q0rpafkwq1fr0766dzyh7dc2r6ws2nwr";
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
