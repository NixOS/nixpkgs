{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wagyu";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "AleoHQ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5n8BmETv5jUvgu0rskAPYaBgYyNL2QU2t/iUb3hNMMw=";
  };

  cargoPatches = [ ./fix-rustc-serialize-version.patch ];

  cargoHash = "sha256-vseTtok0E0ddg9ALQ1ql3NPPxirfyMPHOSWsM2qu2jU=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Rust library for generating cryptocurrency wallets";
    homepage = "https://github.com/AleoHQ/wagyu";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.offline ];
    mainProgram = "wagyu";
  };
}
