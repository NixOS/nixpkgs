{ stdenv, nodejs, fetchzip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "1.5.1";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "13m1y1c2h1fvq8fw1vlmnmnh3jx3l2cx7mz3x55sbgwcinzhkz9m";
  };

  buildInputs = [makeWrapper nodejs];

  installPhase = ''
    mkdir -p $out/{bin,libexec/yarn/}
    cp -R . $out/libexec/yarn
    makeWrapper $out/libexec/yarn/bin/yarn.js $out/bin/yarn
  '';

  meta = with stdenv.lib; {
    homepage = https://yarnpkg.com/;
    description = "Fast, reliable, and secure dependency management for javascript";
    license = licenses.bsd2;
    maintainers = [ maintainers.offline ];
  };
}
