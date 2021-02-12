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

  cargoSha256 = "0f7v0fdqkh01z3j5jb0miyypihskgxbwc2xdpfppkwl3lpj7vgfz";

  postInstall = ''
    install -D udpt.toml $out/share/udpt/udpt.toml
  '';

  meta = {
    description = "A lightweight UDP torrent tracker";
    homepage = "https://naim94a.github.io/udpt";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
