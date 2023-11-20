{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "fw";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fw";
    rev = "v${version}";
    hash = "sha256-8PcIaSXmk6/p5N6L2/nLrFS6JUZRRJsN2mKQYtevS6s=";
  };

  cargoHash = "sha256-l6mRjVk3qNAxfNqcKGo2dceD2Xb+hk+xMvdh/U1jZXw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "A workspace productivity booster";
    homepage = "https://github.com/brocode/fw";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
