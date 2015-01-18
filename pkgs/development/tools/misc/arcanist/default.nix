{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/phacility/libphutil.git";
    rev    = "00f1fcdc19e0d5712f4d8cdb4e6804adc6dfa2ec";
    sha256 = "92031c50c61a8b46b7e978566b1add50dae5849f3c4c2870826d343c4bc458ce";
  };
  arcanist = fetchgit {
    url    = "git://github.com/phacility/arcanist.git";
    rev    = "8173ea3eea73abe12935ffc80fdd65f2d658336b";
    sha256 = "efcbfb42cb879e7589c94c7bf293de996981cf2175935790501c389253aa7f43";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20150118";

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
