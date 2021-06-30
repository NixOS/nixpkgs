{ lib
, stdenv
, fetchurl
, zlib
, libX11
, libpng
}:

stdenv.mkDerivation rec {
  pname = "ploticus";
  version = "2.42";

  src = fetchurl {
    url = "mirror://sourceforge/ploticus/ploticus/${version}/ploticus${lib.replaceStrings [ "." ] [ "" ] version}_src.tar.gz";
    sha256 = "PynkufQFIDqT7+yQDlgW2eG0OBghiB4kHAjKt91m4LA=";
  };

  patches = [
    # Replace hardcoded FHS path with $out.
    ./ploticus-install.patch

    # Set the location of the PREFABS directory.
    ./set-prefabs-dir.patch
  ];

  buildInputs = [
    zlib
    libX11
    libpng
  ];

  hardeningDisable = [ "format" ];

  preBuild = ''
    cd src
  '';

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
    homepage = "http://ploticus.sourceforge.net/";
    platforms = with platforms; linux;
  };
}
