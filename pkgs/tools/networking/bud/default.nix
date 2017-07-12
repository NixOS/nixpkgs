{ stdenv, lib, fetchFromGitHub, python, gyp, utillinux }:

stdenv.mkDerivation rec {
  name = "bud-${version}";

  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "indutny";
    repo = "bud";
    rev = "b112852c9667632f692d2ce3dcd9a8312b61155a";
    sha256 = "0kd35h0iji6myj7b3lxsd0vij72rmab02zlhan6k4f7zwjjc07sy";
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
