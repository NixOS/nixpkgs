{ stdenv, nodejs, fetchzip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "1.9.2";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "0bk006zs1bk6nwj9x07ry314fgxi21sk79h1paljbs6yzrv62h4g";
  };

  buildInputs = [ makeWrapper nodejs ];

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
