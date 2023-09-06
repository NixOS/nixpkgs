{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "zeronsd";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "zeronsd";
    rev = "v${version}";
    hash = "sha256-TL0bgzQgge6j1SpZCdxv/s4pBMSg4/3U5QisjkVE6BE=";
  };

  cargoHash = "sha256-WGap0j90obpJHiMNokCWg0Q3xIAqwvmiESg9NVnFMKE=";

  nativeBuildInputs = [
    pkg-config
    rustfmt
  ];

  RUSTFMT = "${rustfmt}/bin/rustfmt";

  # Integration tests try to access the ZeroTier API which requires an API token.
  # https://github.com/zerotier/zeronsd/blob/v0.5.2/tests/service/network.rs#L10
  doCheck = false;

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "A DNS server for ZeroTier users";
    homepage = "https://github.com/zerotier/zeronsd";
    license = licenses.bsd3;
    maintainers = [ maintainers.dstengele ];
  };
}
