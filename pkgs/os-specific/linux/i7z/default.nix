{ stdenv, lib, fetchFromGitHub, ncurses
, withGui ? false, qt4 ? null }:

stdenv.mkDerivation rec {
  name = "i7z-${version}";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "DimitryAndric";
    repo = "i7z";
    rev = "v${version}";
    sha256 = "0l8wz0ffb27nkwchc606js652spk8masy3kjmzh7ygipwsary5ds";
  };

  buildInputs = [ ncurses ] ++ lib.optional withGui qt4;

  enableParallelBuilding = true;

  postBuild = lib.optionalString withGui ''
      cd GUI
      qmake
      make clean
      make
      cd ..
  '';

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = lib.optionalString withGui ''
    install -Dm755 GUI/i7z_GUI $out/bin/i7z-gui
  '';

  meta = with lib; {
    description = "A better i7 (and now i3, i5) reporting tool for Linux";
    homepage = https://github.com/DimitryAndric/i7z;
    repositories.git = https://github.com/DimitryAndric/i7z.git;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 ];
    # broken on ARM
    platforms = [ "x86_64-linux" ];
  };
}
