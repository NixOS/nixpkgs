{ stdenv, fetchgit, php, flex, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/phacility/libphutil.git";
    rev    = "e509fc30ae782af97f3535b1febbf50d0f919d5a";
    sha256 = "087dc5aadf1f78ebc7cf2b9107422f211b98ac96493fab8cf6bd9924ba77d986";
  };
  arcanist = fetchgit {
    url    = "git://github.com/phacility/arcanist.git";
    rev    = "fe8ed2a6f8b09b8c56e476ed1f9624d35732b776";
    sha256 = "602fe03671c424d55af63e6288e906b350183bb42d558498ded005ae7e83fc85";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20150817";

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
