{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/facebook/libphutil.git";
    rev    = "8d1b522333caf4984180ac830be8635437bacedb";
    sha256 = "e83da381cd8845b64a1cd3244d17736fb736aeabce37efd19754447f47cd4fe1";
  };
  arcanist = fetchgit {
    url    = "git://github.com/facebook/arcanist.git";
    rev    = "0971c728fea89ac45a67e06cdb89349ad8040c60";
    sha256 = "33e595b81dcbef181d3c71072ecf1c22db3f86f49dbb5276c671caefe83c8594";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20140627";

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
