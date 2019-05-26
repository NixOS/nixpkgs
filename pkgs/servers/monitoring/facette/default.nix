{ stdenv, fetchFromGitHub
, go, pkgconfig, nodejs, nodePackages, pandoc, rrdtool }:

stdenv.mkDerivation rec {
  name = "facette-${version}";
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "facette";
    repo = "facette";
    rev = "${version}";
    sha256 = "0p28s2vn18cqg8p7bzhb38wky0m98d5xv3wvf1nmg1kmwhwim6mi";
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
    broken = true; # not really broken, it just requires an internet connection to build. see #45382
  };
}
