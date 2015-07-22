{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/phacility/libphutil.git";
    rev    = "3753a09dfc7e7ee2626946735e420e5b50480f89";
    sha256 = "86c2613fed23edff58452ceb9fa98ceb559c7e41abdb6752f87ebcf0f50a1a66";
  };
  arcanist = fetchgit {
    url    = "git://github.com/phacility/arcanist.git";
    rev    = "4d6d3feb7fc1fb63789554dddee8e489999c1201";
    sha256 = "e3a9314544c4430ac6e67ba2ae180a96b009b3ab848ba8712fc2b308cf880372";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20150707";

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
