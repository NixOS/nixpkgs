{ stdenv, fetchFromGitHub, cmake, qtbase, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "LindeBuzoGrayStippling";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "MarcSpicker";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:1k5izyrw560pyk64v63vjq4vj5n2hp1nxfb6f24h6cjn7ilh21c7";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp LBGStippling $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = "http://graphics.uni-konstanz.de/publikationen/Deussen2017LindeBuzoGray/index.html";
    description = "Interactive Stippling tool to create stippled version of images";
    longDescription = ''
      Stippling is the creation of a pattern simulating varying
      degrees of solidity or shading by using small dots of various
      sizes. The technique can be used both for artistic purposes, but
      also to avoid the use of photographs for websites and print.
      This tool by Marc Spicker from the department of Visual
      Computing from the University of Konstanz was created to support
      a paper for the ACM Transactions on Graphics called "Weighted
      Linde-Buzo-Gray Stippling". Best results are achieved by using
      graphics with high contrast; especially with portraits this
      means you should preprocess with a photo editor. The tool
      on an adaptive version of Lloyd's optimization method that
      distributes points based on Voronoi diagrams.
    '';
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
    license = licenses.gpl3;
  };
}
