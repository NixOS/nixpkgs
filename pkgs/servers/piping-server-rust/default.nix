{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "piping-server-rust";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "nwtgck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7L5YNpQXJQoB/VR/x1HtPfB0F/K0IWcJUb4/wE39Zp0=";
  };

  cargoSha256 = "sha256-t7TJx12CBauWW+1EZ80ouDO4p+0R5jLMaGc/YaPnYRc=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with lib; {
    description = "Infinitely transfer between every device over pure HTTP with pipes or browsers";
    homepage = "https://github.com/nwtgck/piping-server-rust";
    changelog = "https://github.com/nwtgck/piping-server-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "piping-server";
  };
}
