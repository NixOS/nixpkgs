{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "rathole";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-YauQg+P4Y8oO8Kn6FB3NxBI7PHoo/bjS38bM1lFeCH0=";
  };

  cargoHash = "sha256-OcPmHqjW79SKMET6J5HIwmR5vESh+PJcQjSMsqmnIb8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
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
  };
}
