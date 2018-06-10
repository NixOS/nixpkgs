{ stdenv, lib, fetchurl, ncurses
, withGui ? false, qt4 ? null }:

stdenv.mkDerivation rec {
  name = "i7z-0.27.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/i7z/${name}.tar.gz";
    sha256 = "1wa7ix6m75wl3k2n88sz0x8cckvlzqklja2gvzqfw5rcfdjjvxx7";
  };

  buildInputs = [ ncurses ] ++ lib.optional withGui qt4;

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    make
    ${lib.optionalString withGui ''
      cd GUI
      qmake
      make clean
      make
      cd ..
    ''}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,sbin}
    make install prefix=$out
    ${lib.optionalString withGui ''
      install -Dm755 GUI/i7z_GUI $out/bin/i7z-gui
    ''}
    mv $out/sbin/* $out/bin/
    rmdir $out/sbin

    runHook postInstall
  '';

  meta = with lib; {
    description = "A better i7 (and now i3, i5) reporting tool for Linux";
    homepage = https://github.com/ajaiantilal/i7z;
    repositories.git = https://github.com/ajaiantilal/i7z.git;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 ];
    # broken on ARM
    platforms = [ "x86_64-linux" ];
  };
}
