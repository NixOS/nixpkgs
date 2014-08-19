{ stdenv, lib, fetchgit, python, gyp, utillinux }:

stdenv.mkDerivation rec {
  name = "bud-${version}";

  version = "0.25.0";

  src = fetchgit {
    url = "https://github.com/indutny/bud.git";
    rev = "f65b9c3531dac1a5b3c962e01f3bed1d41ab5621";
    sha256 = "000wwc88hsf6ccz8wxjn2af6l0nxm6a2fcad71xw35ymmdp9n5xg";
  };

  buildInputs = [
    python gyp
  ] ++ lib.optional stdenv.isLinux utillinux;
 
  buildPhase = ''
    python ./gyp_bud -f make
    make -C out
  '';

  installPhase = ''
    ensureDir $out/bin
    cp out/Release/bud $out/bin
  '';

  meta = with lib; {
    description = "A TLS terminating proxy";
    license     = licenses.mit;
    platforms   = with platforms; linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
