{ lib, stdenv, fetchurl, makeWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "ktlint";
  version = "0.40.0";

  src = fetchurl {
    url = "https://github.com/shyiko/ktlint/releases/download/${version}/ktlint";
    sha256 = "17n1xdalz38h9p4ylcpkbbqp22b1np5l8y5l3r58kaf9k8p6cfa7";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/ktlint
  '';

  postFixup = ''
    wrapProgram $out/bin/ktlint --prefix PATH : "${jre_headless}/bin"
  '';

  meta = with lib; {
    description = "An anti-bikeshedding Kotlin linter with built-in formatter";
    homepage = "https://ktlint.github.io/";
    license = licenses.mit;
    platforms = jre_headless.meta.platforms;
    maintainers = with maintainers; [ tadfisher ];
  };
}
