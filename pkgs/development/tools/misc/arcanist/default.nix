{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/phacility/libphutil.git";
    rev    = "b25e0477b280ca3e8345bb97cd55e95bcb5023ec";
    sha256 = "0dhf2n42qf1dnp6whhfcqf6pllxhfpfv77r5irzjndirp0j1z9kn";
  };
  arcanist = fetchgit {
    url    = "git://github.com/phacility/arcanist.git";
    rev    = "2234c8cacc21ce61c9c10e8e5918b6a63cc38fc8";
    sha256 = "1ljnk5vhhd0kgc6r1zymnz30c5yyc1yl8wiqmwqb3si4ns580h23";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20160516";

  src = [ arcanist libphutil ];
  buildInputs = [ php makeWrapper flex ];

  unpackPhase = "true";
  buildPhase = ''
    ORIG=`pwd`
    cp -R ${libphutil} libphutil
    cp -R ${arcanist} arcanist
    chmod +w -R libphutil arcanist
    cd libphutil/support/xhpast
    make clean all install
    cd $ORIG
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
