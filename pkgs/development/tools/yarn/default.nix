{ stdenv, nodejs, fetchzip }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "1.13.0";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "0wkh8m41g5sajxlchsaqardn4v2ax06xywk12fwdjn5j3sxlgq2a";
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
