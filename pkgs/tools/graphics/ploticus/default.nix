{ lib
, stdenv
, fetchurl
, zlib
, libX11
, libpng
, libjpeg
, gd
, freetype
, runCommand
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "ploticus";
  version = "2.42";

  src = fetchurl {
    url = "mirror://sourceforge/ploticus/ploticus/${version}/ploticus${lib.replaceStrings [ "." ] [ "" ] version}_src.tar.gz";
    sha256 = "PynkufQFIDqT7+yQDlgW2eG0OBghiB4kHAjKt91m4LA=";
  };

  patches = [
    # Replace hardcoded FHS path with $out.
    ./ploticus-install.patch

    # Use gd from Nixpkgs instead of the vendored one.
    # This is required for non-ASCII fonts to work:
    # https://ploticus.sourceforge.net/doc/fonts.html
    ./use-gd-package.patch
  ];

  buildInputs = [
    zlib
    libX11
    libpng
    gd
    freetype
    libjpeg
  ];

  hardeningDisable = [ "format" ];

  preBuild = ''
    cd src
    # Set the location of the PREFABS directory.
    sed -i -e 's,PREFABS_DIR "",PREFABS_DIR "'$out'/share/ploticus/prefabs",' pl.h
  '';
  makeFlags = [ "CC=cc" ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  postInstall = ''
    cd ..

    # Install the “prefabs”.
    mkdir -p "$out/share/ploticus/prefabs"
    cp -rv prefabs/* "$out/share/ploticus/prefabs"

    # Add aliases for backwards compatibility.
    ln -s "pl" "$out/bin/ploticus"
  '';

  passthru.tests = {
    simple = runCommand "${pname}-prefab-test" {
      buildInputs = [ finalAttrs.finalPackage ];
    } ''
      # trivial test to see if the prefab path munging works
      mkdir $out/
      pl -prefab scat inlinedata="A 1 2" x=2 y=3 -png -o $out/out.png
    '';
  };

  meta = with lib; {
    description = "A non-interactive software package for producing plots and charts";
    longDescription = ''
      Ploticus is a free, GPL'd, non-interactive
      software package for producing plots, charts, and graphics from
      data.  Ploticus is good for automated or just-in-time graph
      generation, handles date and time data nicely, and has basic
      statistical capabilities.  It allows significant user control
      over colors, styles, options and details.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    homepage = "https://ploticus.sourceforge.net/";
    platforms = with platforms; linux ++ darwin;
  };
})
