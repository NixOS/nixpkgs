{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/facebook/libphutil.git";
    rev    = "7e75bf271c669b61eb6e6e2ea312a36e64b80a4a";
    sha256 = "ffb7ee8141b925889e9bbc945d2f38f12d1489148b9c9b7eaeadd7524d254a78";
  };
  arcanist = fetchgit {
    url    = "git://github.com/facebook/arcanist.git";
    rev    = "50caec620a8ed45c54323cb71fee72fd0d935115";
    sha256 = "dd18ed22375ad1ba058703952be0d339d9c93704e9d75dd7e4e6625236dfe9b0";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20140606";

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
