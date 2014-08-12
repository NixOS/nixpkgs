{stdenv, fetchurl, lua, curl}:
let
  s = # Generated upstream information
  rec {
    baseName="luarocks";
    version="2.2";
    name="${baseName}-${version}";
    hash="03i46ayimp087288f0bi6g30fi3aixp2bha2jmsbbhwmsxm1yshs";
    url="http://luarocks.org/releases/luarocks-2.2.0beta1.tar.gz";
    sha256="03i46ayimp087288f0bi6g30fi3aixp2bha2jmsbbhwmsxm1yshs";
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
