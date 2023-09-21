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
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yqZPs0rp3LD7n4+JGa55gZ4xMcumy+oazrxCqpDzIfQ=";
  };

  cargoHash = "sha256-BZ6AgH/wnxrDLkyncR0pbayae9v5P7X7UnlJ48JR8sM=";

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
