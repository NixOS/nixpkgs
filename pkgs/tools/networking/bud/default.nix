{ stdenv, lib, fetchgit, python, gyp, utillinux }:

stdenv.mkDerivation rec {
  name = "bud-${version}";

  version = "0.34.1";

  src = fetchgit {
    url = "https://github.com/indutny/bud.git";
    rev = "b112852c9667632f692d2ce3dcd9a8312b61155a";
    sha256 = "1acvsx71fmmqhqf00ria3rbq453476x1jx0x8rp6nds5nx2mi0np";
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
    platforms   = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
