{ stdenv, nodejs, fetchzip, makeWrapper }:

stdenv.mkDerivation rec {
  name = "yarn-${version}";
  version = "1.7.0";

  src = fetchzip {
    url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "00fxihv9ih40k6f21a7hb6vkx4h4m6ks0fbai5h9ssi0p4m5j3by";
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
