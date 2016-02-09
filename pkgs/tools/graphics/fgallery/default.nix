{ stdenv, fetchurl, unzip, makeWrapper, perl, ImageExifTool, JSON
, coreutils, zip, imagemagick, pngcrush, lcms2, fbida
}:

# TODO: add optional dependencies (snippet from fgallery source):
#
# if(system("jpegoptim -V >/dev/null 2>&1")) {
#   $jpegoptim = 0;
# }
# if($facedet && system("facedetect -h >/dev/null 2>&1")) {
#   fatal("cannot run \"facedetect\" (see http://www.thregr.org/~wavexx/hacks/facedetect/)");

stdenv.mkDerivation rec {
  name = "fgallery-1.8";

  src = fetchurl {
    url = "http://www.thregr.org/~wavexx/software/fgallery/releases/${name}.zip";
    sha256 = "1n237sk7fm4yrpn69qaz9fwbjl6i94y664q7d16bhngrcil3bq1d";
  };

  buildInputs = [ unzip makeWrapper perl ImageExifTool JSON ];

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
        --set PATH "${stdenv.lib.makeSearchPath "bin"
                     [ coreutils zip imagemagick pngcrush lcms2 fbida ]}"
  '';

  meta = with stdenv.lib; {
    description = "Static photo gallery generator";
    homepage = http://www.thregr.org/~wavexx/software/fgallery/;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
