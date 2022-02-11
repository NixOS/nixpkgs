{ stdenv, lib, fetchgit, python2, util-linux }:

stdenv.mkDerivation {
  pname = "bud";

  version = "0.34.1";

  src = fetchgit {
    url = "https://github.com/indutny/bud.git";
    rev = "b112852c9667632f692d2ce3dcd9a8312b61155a";
    sha256 = "08yr6l4lc2m6rng06253fcaznf6sq0v053wfr8bbym42c32z0xdh";
  };

  nativeBuildInputs = [
    python2 python2.pkgs.gyp
  ] ++ lib.optional stdenv.isLinux util-linux;

  strictDeps = true;

  buildPhase = ''
    python ./gyp_bud -f make
    make -C out
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp out/Release/bud $out/bin
  '';

  meta = with lib; {
    description = "A TLS terminating proxy";
    license     = licenses.mit;
    platforms   = platforms.linux;
    # Does not build on aarch64-linux.
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with maintainers; [ cstrahan ];
  };
}
