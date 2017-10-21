{ stdenv, fetchFromGitHub, php, flex, makeWrapper }:

let
  libphutil = fetchFromGitHub {
    owner = "phacility";
    repo = "libphutil";
    rev = "01b33af6f4d570b34ad791cd5ccaa3ea7f77dcb9";
    sha256 = "0glrxlj4cr2821pdc2yy2m5bss4yr1zx3sdgw3r5d8hbfz361nx7";
  };
  arcanist = fetchFromGitHub {
    owner = "phacility";
    repo = "arcanist";
    rev = "3b6b523c2b236e3724a1e115f126cb6fd05fa128";
    sha256 = "1pr2izwj446rf2v6x6v2wsj7iwnaxq3xg3qqipybyf1xpqfmh5q8";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20170323";

  src = [ arcanist libphutil ];
  buildInputs = [ php makeWrapper flex ];

  unpackPhase = "true";
  buildPhase = ''
    cp -R ${libphutil} libphutil
    cp -R ${arcanist} arcanist
    chmod +w -R libphutil arcanist
    (
      cd libphutil/support/xhpast
      make clean all install
    )
  '';
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -R libphutil $out/libexec/libphutil
    cp -R arcanist  $out/libexec/arcanist

    ln -s $out/libexec/arcanist/bin/arc $out/bin
    wrapProgram $out/bin/arc \
      --prefix PATH : "${php}/bin"
  '';

  meta = {
    description = "Command line interface to Phabricator";
    homepage    = "http://phabricator.org";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
