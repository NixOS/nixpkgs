{ stdenv, nodejs, fetchzip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "0.18.1";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "1jkgd2d0n78jw66a0v3cgawcc9qvzjy1zp8c1wzfqf0hl5wrcv9q";
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
