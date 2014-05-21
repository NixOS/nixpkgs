{ stdenv, fetchgit, php }:

let
  libphutil = fetchgit {
    url    = "git://github.com/facebook/libphutil.git";
    rev    = "1ba1de50e9ee1ca63e472f625282346693eb0a18";
    sha256 = "d571906b6ecb3700f0d57498426d2ab2a5fbed469d739ee1e03d410215738d2f";
  };
  arcanist = fetchgit {
    url    = "git://github.com/facebook/arcanist.git";
    rev    = "c999f3e6b5c7edef82761ed1db00d79683e2e37a";
    sha256 = "d1d9f5ada8ffcb02f03210356c5087019e164f456660469e2825dcbdf5f07d35";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20140521";

  src = [ arcanist libphutil ];
  buildInputs = [ php ];

  unpackPhase = "true";
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -R ${libphutil} $out/libexec/libphutil
    cp -R ${arcanist}  $out/libexec/arcanist

    ln -s $out/libexec/arcanist/bin/arc $out/bin
  '';

  meta = {
    description = "Command line interface to Phabricator";
    homepage    = "http://phabricator.org";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
