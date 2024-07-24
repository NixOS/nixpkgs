{ lib, stdenv, fetchurl, unzip, makeWrapper, perlPackages
, coreutils, zip, imagemagick, pngcrush, lcms2
, facedetect, fbida }:

# TODO: add optional dependencies (snippet from fgallery source):
#
# if(system("jpegoptim -V >/dev/null 2>&1")) {
#   $jpegoptim = 0;
# }

stdenv.mkDerivation rec {
  pname = "fgallery";
  version = "1.9.1";

  src = fetchurl {
    url = "https://www.thregr.org/~wavexx/software/fgallery/releases/fgallery-${version}.zip";
    hash = "sha256-FvF0wkRe3wTPUG9/GEBxkaxvZ1B4wEd9kI9rURHKxn0=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = (with perlPackages; [ perl ImageExifTool CpanelJSONXS ]);

  postPatch = ''
    substituteInPlace Makefile \
      --replace "/usr" $out
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/fgallery"

    cp -r * "$out/share/fgallery"
    ln -s -r "$out/share/fgallery/fgallery" "$out/bin/fgallery"

    # Don't preserve file attributes when copying files to output directories.
    # (fgallery copies parts of itself to each output directory, and without
    # this change the read-only nix store causes some bumps in the workflow.)
    sed -i -e "s|'cp'|'cp', '--no-preserve=all'|g" "$out/share/fgallery/fgallery"

    wrapProgram "$out/share/fgallery/fgallery" \
        --set PERL5LIB "$PERL5LIB" \
        --set PATH "${lib.makeBinPath
                     [ coreutils zip imagemagick pngcrush lcms2 facedetect fbida ]}"
  '';

  meta = with lib; {
    description = "Static photo gallery generator";
    homepage = "https://www.thregr.org/~wavexx/software/fgallery/";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "fgallery";
  };
}
