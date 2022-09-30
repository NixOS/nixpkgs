{ lib, fetchurl, perlPackages, ncurses, lynx, makeWrapper }:

perlPackages.buildPerlPackage {
  pname = "wml";
  version = "2.0.11";

  src = fetchurl {
    url = "http://thewml.org/distrib/wml-2.0.11.tar.gz";
    sha256 = "0jjxpq91x7y2mgixz7ghqp01m24qa37wl3zz515rrzv7x8cyy4cf";
  };

  setOutputFlags = false;

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

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages;
    [ perl TermReadKey GD BitVector ncurses lynx ImageSize ];

  patches = [ ./redhat-with-thr.patch ./dynaloader.patch ./no_bitvector.patch ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: iselect_browse.o:(.bss+0x2020): multiple definition of `Line'; iselect_main.o:(.bss+0x100000): first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

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
      --set PERL5LIB ${with perlPackages; makePerlPath [
        BitVector TermReadKey ImageSize
      ]}
  '';

  enableParallelBuilding = false;

  installTargets = [ "install" ];

  meta = with lib; {
    homepage = "https://www.shlomifish.org/open-source/projects/website-meta-language/";
    description = "Off-line HTML generation toolkit for Unix";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
