{ stdenv, fetchurl, gnuplot, ruby }:

stdenv.mkDerivation {
  name = "eplot-2.07";

  # Upstream has been contacted (2015-03) regarding providing versioned
  # download URLs. Initial response was positive, but no action yet.
  src = fetchurl {
    url = "http://liris.cnrs.fr/christian.wolf/software/eplot/download/eplot";
    sha256 = "0y9x82i3sfpgxsqz2w42r6iad6ph7vxb7np1xbwapx5iipciclw5";
  };

  ecSrc = fetchurl {
    url = "http://liris.cnrs.fr/christian.wolf/software/eplot/download/ec";
    sha256 = "0fg31g8mrcx14h2rjcf091cbd924n19z55iscaiflspifya30yhd";
  };

  buildInputs = [ ruby ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp "$src" "$out/bin/eplot"
    cp "$ecSrc" "$out/bin/ec"
    chmod +x "$out/bin/"*

    sed -i -e "s|gnuplot -persist|${gnuplot}/bin/gnuplot -persist|" "$out/bin/eplot"
  '';

  meta = with stdenv.lib; {
    description = "Create plots quickly with gnuplot";
    longDescription = ''
      eplot ("easy gnuplot") is a ruby script which allows to pipe data easily
      through gnuplot and create plots quickly, which can be saved in
      postscript, PDF, PNG or EMF files. Plotting of multiple files into a
      single diagram is supported.

      This package also includes the complementary 'ec' tool (say "extract
      column").
    '';
    homepage = http://liris.cnrs.fr/christian.wolf/software/eplot/;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
