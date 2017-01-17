{ stdenv, nodejs, fetchzip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "0.19.1";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "1006ijhig9pcmrlsqfwxhn4i78bcji2grvkl4hz64fmqv6rh783s";
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
