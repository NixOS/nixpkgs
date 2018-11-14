{ stdenv, nodejs, fetchzip }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "1.12.3";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "0izn7lfvfw046qlxdgiiiyqj24sl2yclm6v8bzy8ilsr00csbrm2";
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
