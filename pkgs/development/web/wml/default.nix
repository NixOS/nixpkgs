{ stdenv, fetchurl, perlPackages, ncurses, lynx, makeWrapper }:

perlPackages.buildPerlPackage rec {
  name = "wml-2.0.11";

  src = fetchurl {
    url = "http://thewml.org/distrib/${name}.tar.gz";
    sha256 = "0jjxpq91x7y2mgixz7ghqp01m24qa37wl3zz515rrzv7x8cyy4cf";
  };

  preConfigure = "touch Makefile.PL";
  
  buildInputs = [ perlPackages.perl ncurses lynx makeWrapper ];

  patches = [ ./redhat-with-thr.patch ./dynaloader.patch ./no_bitvector.patch ];

  preFixup = ''
    substituteInPlace $out/bin/wml \
      --replace "File::PathConvert::realpath" "Cwd::realpath" \
      --replace "File::PathConvert::abs2rel" "File::Spec->abs2rel" \
      --replace "File::PathConvert" "File::Spec"

    wrapProgram $out/bin/wml \
      --set PERL5LIB ${with perlPackages; stdenv.lib.makePerlPath [
        BitVector TermReadKey ImageSize
      ]}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://thewml.org/;
    description = "Off-line HTML generation toolkit for Unix";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}