{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "bitwarden_rs-vault";
  version = "2.13.2b";

  src = fetchurl {
    url = "https://github.com/dani-garcia/bw_web_builds/releases/download/v${version}/bw_web_v${version}.tar.gz";
    sha256 = "1pba3d04gfnviv8r98anpv7m8r9r417s352r5fz8qzg8lr070540";
  };

  buildCommand = ''
    mkdir -p $out/share/bitwarden_rs/
    cd $out/share/bitwarden_rs/
    tar xf $src
    mv web-vault vault
  '';

  meta = with stdenv.lib; {
    description = "Integrates the web vault into bitwarden_rs";
    homepage = "https://github.com/dani-garcia/bw_web_builds";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
  };
}
