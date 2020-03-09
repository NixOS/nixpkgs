{ stdenv, nodejs, fetchzip }:

stdenv.mkDerivation rec {
  pname = "yarn";
  version = "1.22.0";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "0hbsdbrqx5xhr171ik862v51xwjzbfncic92pgbnhnlmxy2y974x";
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
    maintainers = with maintainers; [ offline screendriver ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
