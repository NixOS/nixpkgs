{ stdenv, fetchurl, perlPackages, ncurses, lynx, makeWrapper }:

perlPackages.buildPerlPackage rec {
  name = "wml-2.0.11";

  src = fetchurl {
    url = "http://thewml.org/distrib/${name}.tar.gz";
    sha256 = "0jjxpq91x7y2mgixz7ghqp01m24qa37wl3zz515rrzv7x8cyy4cf";
  };

  # Getting lots of Non-ASCII character errors from pod2man.
  # Inserting =encoding utf8 before the first =head occurrence.
  # Wasn't able to fix mp4h.
  preConfigure = ''
    touch Makefile.PL
    for i in wml_backend/p6_asubst/asubst.src wml_aux/freetable/freetable.src wml_docs/*.pod wml_include/des/*.src wml_include/fmt/*.src; do
      sed -i '0,/^=head/{s/^=head/=encoding utf8\n=head/}' $i
    done
    sed -i 's/ doc / /g' wml_backend/p2_mp4h/Makefile.in
    sed -i '/p2_mp4h\/doc/d' Makefile.in
  '';

  buildInputs = with perlPackages; 
    [ perl TermReadKey GD BitVector ncurses lynx makeWrapper ImageSize ];

  patches = [ ./redhat-with-thr.patch ./dynaloader.patch ./no_bitvector.patch ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace wml_frontend/wml.src \
      --replace "File::PathConvert::realpath" "Cwd::realpath" \
      --replace "File::PathConvert::abs2rel" "File::Spec->abs2rel" \
      --replace "File::PathConvert" "File::Spec"

    for i in wml_include/des/imgbg.src wml_include/des/imgdot.src; do
      substituteInPlace $i \
        --replace "WML::GD" "GD"
    done

    rm wml_test/t/11-wmk.t
  '';

  preFixup = ''
    wrapProgram $out/bin/wml \
      --set PERL5LIB ${with perlPackages; stdenv.lib.makePerlPath [
        BitVector TermReadKey ImageSize
      ]}
  '';

  enableParallelBuilding = false;

  installTargets = "install";

  meta = with stdenv.lib; {
    homepage = http://thewml.org/;
    description = "Off-line HTML generation toolkit for Unix";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
