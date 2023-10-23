{lib, stdenv, fetchzip, libtommath}:

stdenv.mkDerivation rec {
  pname = "convertlit";
  version = "1.8";

  src = fetchzip {
    url = "http://www.convertlit.com/convertlit${lib.replaceStrings ["."] [""] version}src.zip";
    sha256 = "182nsin7qscgbw2h92m0zadh3h8q410h5cza6v486yjfvla3dxjx";
    stripRoot = false;
  };

  buildInputs = [libtommath];

  hardeningDisable = [ "format" ];

  buildPhase = ''
    runHook preBuild

    cd lib
    make
    cd ../clit18
    substituteInPlace Makefile \
      --replace ../libtommath-0.30/libtommath.a -ltommath
    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp clit $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.convertlit.com/";
    description = "A tool for converting Microsoft Reader ebooks to more open formats";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
