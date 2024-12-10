{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "udpt";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "naim94a";
    repo = "udpt";
    rev = "${pname}-${version}";
    sha256 = "sha256-G3LzbV3b1Y/2SPIBS1kZDuLuGF5gV/H1LFBRhevpdjU=";
  };

  cargoSha256 = "sha256-ebLVyUB65fW8BWctxXnYxrnl/2IESd4YJXeiMsMXn9s=";

  postInstall = ''
    install -D udpt.toml $out/share/udpt/udpt.toml
  '';

  meta = {
    description = "A lightweight UDP torrent tracker";
    homepage = "https://naim94a.github.io/udpt";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "udpt-rs";
  };
}
