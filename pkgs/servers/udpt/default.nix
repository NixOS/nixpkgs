{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "udpt";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "naim94a";
    repo = "udpt";
    rev = "${pname}-${version}";
    sha256 = "1g6l0y5x9pdra3i1npkm474glysicm4hf2m01700ack2rp43vldr";
  };

  cargoSha256 = "0raym4zrapn3w0a98y9amyp2qh7swd73cjslsfgfzlr9w8vsb6zs";

  postInstall = ''
    install -D udpt.toml $out/share/udpt/udpt.toml
  '';

  meta = {
    description = "A lightweight UDP torrent tracker";
    homepage = "https://naim94a.github.io/udpt";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
