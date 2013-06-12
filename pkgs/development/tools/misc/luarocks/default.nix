{stdenv, fetchurl, lua, curl}:
let
  s = # Generated upstream information
  rec {
    baseName="luarocks";
    version="2.0.13";
    name="${baseName}-${version}";
    hash="1cpdi61dwcc2i4bwrn7bb8fibkd1s75jrr0bjcbs8p76rn6hkb2y";
    url="http://luarocks.org/releases/luarocks-2.0.13-rc1.tar.gz";
    sha256="1cpdi61dwcc2i4bwrn7bb8fibkd1s75jrr0bjcbs8p76rn6hkb2y";
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
