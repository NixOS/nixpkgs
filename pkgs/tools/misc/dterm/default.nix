{ lib, stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  pname = "dterm";
  version = "0.5";

  src = fetchurl {
    url = "http://www.knossos.net.nz/downloads/dterm-${version}.tgz";
    sha256 = "94533be79f1eec965e59886d5f00a35cb675c5db1d89419f253bb72f140abddb";
  };

  buildInputs = [ readline ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace 'gcc' '${stdenv.cc.targetPrefix}cc'
  '';
  preInstall = "mkdir -p $out/bin";
  installFlags = [ "BIN=$(out)/bin/" ];

  meta = with lib; {
    homepage = "http://www.knossos.net.nz/resources/free-software/dterm/";
    description = "A simple terminal program";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ auchter ];
    platforms = platforms.unix;
  };
}
