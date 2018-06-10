{ stdenv, fetchFromGitHub
, go, pkgconfig, nodejs, nodePackages, pandoc, rrdtool }:

stdenv.mkDerivation rec {
  name = "facette-${version}";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "facette";
    repo = "facette";
    rev = "${version}";
    sha256 = "1m7krq439qlf7b4l4bfjw0xfvjgj67w59mh8rf7c398rky04p257";
  };
  nativeBuildInputs = [ go pkgconfig nodejs nodePackages.npm pandoc ];
  buildInputs = [ rrdtool ];
  preBuild = ''
    export HOME="$NIX_BUILD_ROOT" # npm needs a writable home
  '';
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Time series data visualization software";
    longDescription = ''
      Facette is a web application to display time series data from various
      sources — such as collectd, Graphite, InfluxDB or KairosDB — on graphs.
    '';
    homepage = https://facette.io/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
  };
}
