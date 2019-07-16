{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "bitwarden_rs-vault";
  version = "2.10.1";

  src = fetchurl {
    url = "https://github.com/dani-garcia/bw_web_builds/releases/download/v${version}/bw_web_v${version}.tar.gz";
    sha256 = "1avgxlsxi7mb8zpqai3j1qb43qq09ya5ngb7l4q7mj0d89lxrzhb";
  };

  buildCommand = ''
    mkdir -p $out/share/bitwarden_rs/vault
    cd $out/share/bitwarden_rs/vault
    tar xf $src
  '';

  meta = with stdenv.lib; {
    description = "Integrates the web vault into bitwarden_rs";
    homepage = https://github.com/dani-garcia/bw_web_builds;
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
  };
}
