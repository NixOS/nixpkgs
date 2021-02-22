{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bitwarden_rs-vault";
  version = "2.18.1b";

  src = fetchurl {
    url = "https://github.com/dani-garcia/bw_web_builds/releases/download/v${version}/bw_web_v${version}.tar.gz";
    sha256 = "sha256-MwHTx4ITr2GuBS6qXD4m3aCinpJHQa0Wp0Bbmgg7ATQ=";
  };

  buildCommand = ''
    mkdir -p $out/share/bitwarden_rs/
    cd $out/share/bitwarden_rs/
    tar xf $src
    mv web-vault vault
  '';

  passthru.tests = nixosTests.bitwarden;

  meta = with lib; {
    description = "Integrates the web vault into bitwarden_rs";
    homepage = "https://github.com/dani-garcia/bw_web_builds";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ msteen mic92 ];
  };
}
