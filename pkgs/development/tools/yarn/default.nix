{ lib, stdenv, nodejs, fetchzip, testVersion, yarn }:

stdenv.mkDerivation rec {
  pname = "yarn";
  version = "1.22.17";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "1skzlyv2976bl1063f94422jbjy4ns1nxl622biizq31z4821yvj";
  };

  buildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out/{bin,libexec/yarn/}
    cp -R . $out/libexec/yarn
    ln -s $out/libexec/yarn/bin/yarn.js $out/bin/yarn
    ln -s $out/libexec/yarn/bin/yarn.js $out/bin/yarnpkg
  '';

  passthru.tests = testVersion { package = yarn; };

  meta = with lib; {
    homepage = "https://yarnpkg.com/";
    description = "Fast, reliable, and secure dependency management for javascript";
    license = licenses.bsd2;
    maintainers = with maintainers; [ offline screendriver ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
