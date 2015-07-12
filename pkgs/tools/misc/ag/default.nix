{ stdenv, fetchurl, pkgs }:

stdenv.mkDerivation rec {
  version = "0.30.0";
  name = "ag-${version}";

  src = fetchurl {
    url = "https://github.com/ggreer/the_silver_searcher/archive/${version}.tar.gz";
    sha256 = "1nx5glgd0x55z073qcaazav5sm0jfvxai2bykkldniv6z601pdm3";
  };

  buildInputs = with pkgs; [ autoconf automake pkgconfig gnugrep.pcre lzma ];

  configurePhase = ''
    sed -i 's,:/usr/local/bin/,,' build.sh
    ./build.sh PREFIX=$out
  '';

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    make PREFIX=$out prefix=$out install
  '';

  meta = with stdenv.lib; {
    description = "A code-searching tool similar to ack, but faster";
    homepage = "http://geoff.greer.fm/ag/";
    license = license.asl20;
    platforms = platforms.linux; # can only test on linux
    maintainers = [ maintainers.matthiasbeyer ];
  };
}

