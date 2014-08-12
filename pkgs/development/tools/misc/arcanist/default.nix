{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/facebook/libphutil.git";
    rev    = "d8c026530d7f442eb0f93233b536cfb06aec911d";
    sha256 = "6cbeb5b7640371f95ef017f3382f33a985a5c417f69e837fbb3b59c0332b5ecf";
  };
  arcanist = fetchgit {
    url    = "git://github.com/facebook/arcanist.git";
    rev    = "a9535446579af33dfa50f60dcc79c9edf633eebd";
    sha256 = "8468f3beecdce2f62dc010ddade8ffbf0a8802f23ee88b91e09c09f173e692f6";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20140717";

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
