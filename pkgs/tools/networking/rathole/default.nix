{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "rathole";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-YfLzR1lHk+0N3YU1XTNxz+KE1S3xaiKJk0zASm6cr1s=";
  };

  cargoHash = "sha256-UyQXAUPnp32THZJAs/p3bIXZjcXTvjy207QBVLCfkr8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      CoreServices
    ];

  __darwinAllowLocalNetworking = true;

  doCheck = false; # https://github.com/rapiz1/rathole/issues/222

  meta = with lib; {
    description = "Reverse proxy for NAT traversal";
    homepage = "https://github.com/rapiz1/rathole";
    changelog = "https://github.com/rapiz1/rathole/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "rathole";
  };
}
