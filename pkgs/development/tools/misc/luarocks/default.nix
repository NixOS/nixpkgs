{stdenv, fetchurl, lua, curl}:
let
  s = # Generated upstream information
  rec {
    baseName="luarocks";
    version="2.1.0";
    name="${baseName}-${version}";
    hash="12aqwchzn77yin2ahpxnc3lam5w0xhksrnhf31n3r7cxdsfh446c";
    url="http://luarocks.org/releases/luarocks-2.1.0-rc3.tar.gz";
    sha256="12aqwchzn77yin2ahpxnc3lam5w0xhksrnhf31n3r7cxdsfh446c";
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
