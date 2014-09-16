{ stdenv, lib, fetchgit, python, gyp, utillinux }:

stdenv.mkDerivation rec {
  name = "bud-${version}";

  version = "0.32.0";

  src = fetchgit {
    url = "https://github.com/indutny/bud.git";
    rev = "1bfcc8c73c386f0ac12763949cd6c214058900a6";
    sha256 = "1lfq6q026yawi0ps0gf0nl9a76qkpcc40r3v7zrj9cxzjb9fcymc";
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
