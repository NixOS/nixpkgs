{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "convmv";
  version = "2.05";

  src = fetchurl {
    url = "https://www.j3e.de/linux/convmv/convmv-${version}.tar.gz";
    sha256 = "19hwv197p7c23f43vvav5bs19z9b72jzca2npkjsxgprwj5ardjk";
  };

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  patchPhase = ''
    tar -xf testsuite.tar
    patchShebangs .
  '';

  doCheck = true;
  checkTarget = "test";

  buildInputs = [ perl ];

  meta = with lib; {
    description = "Converts filenames from one encoding to another";
    platforms = platforms.linux ++ platforms.freebsd ++ platforms.cygwin;
    maintainers = [ ];
    license = licenses.gpl2Plus;
    mainProgram = "convmv";
  };
}
