{ stdenv, nodejs, fetchzip }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "1.14.0";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "167lpw4bnw8845ip6cvdk827lwdbprisd7ygl7vqv4p1wgdcrkqq";
  };

  buildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out/{bin,libexec/yarn/}
    cp -R . $out/libexec/yarn
    ln -s $out/libexec/yarn/bin/yarn.js $out/bin/yarn
    ln -s $out/libexec/yarn/bin/yarn.js $out/bin/yarnpkg
  '';

  meta = with stdenv.lib; {
    homepage = https://yarnpkg.com/;
    description = "Fast, reliable, and secure dependency management for javascript";
    license = licenses.bsd2;
    maintainers = [ maintainers.offline maintainers.screendriver ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
