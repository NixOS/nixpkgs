{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/facebook/libphutil.git";
    rev    = "49f08a756a54f12405d3704c0f978b71c7b13811";
    sha256 = "b32267fe19c6e9532887388815b8553519e2844bc5b839b5ad35efeab6b07fb8";
  };
  arcanist = fetchgit {
    url    = "git://github.com/facebook/arcanist.git";
    rev    = "4c0edd296e3301fffdda33c447f6fcafe7d1de01";
    sha256 = "a9f162fb6b47bcf628130e0e8988ab650278b3a6606fa425e4707241ed22dd3e";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20140812";

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
