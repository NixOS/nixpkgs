{ stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bitwarden_rs-vault";
  version = "2.16.1";

  src = fetchurl {
    url = "https://github.com/dani-garcia/bw_web_builds/releases/download/v${version}/bw_web_v${version}.tar.gz";
    sha256 = "1c4fcf8jzgd6636wv903r5msc9z5l56l2i4k93kvb2zvg7qj014w";
  };

  buildCommand = ''
    mkdir -p $out/share/bitwarden_rs/
    cd $out/share/bitwarden_rs/
    tar xf $src
    mv web-vault vault
  '';

  passthru.tests = nixosTests.bitwarden;

  meta = with stdenv.lib; {
    description = "Integrates the web vault into bitwarden_rs";
    homepage = "https://github.com/dani-garcia/bw_web_builds";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
  };
}
