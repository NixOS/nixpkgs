{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "bitwarden_rs-vault";
  version = "2.12.0c";

  src = fetchurl {
    url = "https://github.com/dani-garcia/bw_web_builds/releases/download/v${version}/bw_web_v${version}.tar.gz";
    sha256 = "040bqbx6hpwq4qvv4s7d77gwp5n2ay9rr7kdb135582d80wjq5sp";
  };

  buildCommand = ''
    mkdir -p $out/share/bitwarden_rs/vault
    cd $out/share/bitwarden_rs/vault
    tar xf $src
  '';

  meta = with stdenv.lib; {
    description = "Integrates the web vault into bitwarden_rs";
    homepage = "https://github.com/dani-garcia/bw_web_builds";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
  };
}
