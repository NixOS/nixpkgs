{ stdenv, lib, fetchurl, undmg, ... }:

stdenv.mkDerivation rec {
  version = "3.0.1";
  pname = "grandperspective";

  src = fetchurl {
    inherit version;
    url = "mirror://sourceforge/grandperspectiv/GrandPerspective-${builtins.replaceStrings [ "." ] [ "_" ] version}.dmg";
    sha256 = "sha256-ZPqrlN9aw5q7656GmmxCnTRBw3lu9n952rIyun8MsiI=";
  };

  sourceRoot = "GrandPerspective.app";
  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/GrandPerspective.app";
    cp -R . "$out/Applications/GrandPerspective.app";
  '';

  meta = with lib; {
    description = "Open-source macOS application to analyze disk usage";
    longDescription = ''
      GrandPerspective is a small utility application for macOS that graphically shows the disk usage within a file
      system. It can help you to manage your disk, as you can easily spot which files and folders take up the most
      space. It uses a so called tree map for visualisation. Each file is shown as a rectangle with an area proportional to
      the file's size. Files in the same folder appear together, but their placement is otherwise arbitrary.
    '';
    homepage = "https://grandperspectiv.sourceforge.net";
    license = licenses.gpl2;
    maintainers = with maintainers; [ eliandoran ];
    platforms = [ "x86_64-darwin" ];
  };

}
