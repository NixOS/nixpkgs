{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/phacility/libphutil.git";
    rev    = "ce3959b4046f5dcc4f3413a59328bda2a42e76b0";
    sha256 = "3c206b428fa5e0391868f7782db4af4d1cf2f338899831a36771cef74db14a76";
  };
  arcanist = fetchgit {
    url    = "git://github.com/phacility/arcanist.git";
    rev    = "b961869edac9469be93f2c3ac7a24562d3186860";
    sha256 = "2ae1272c76a1e2bdedd87d453ddb75f6110f9224063e7ee39e88fcb8b3b4c884";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20150318";

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
