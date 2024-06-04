{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zNsNEXj/SaJaYsYvoOGPopLhJDfLIXSs7eeZDdJrHiQ=";
  };

  cargoHash = "sha256-gtqdQuf3Ybt0PDCQw3gGAzIROq39NJKPIat0lyIPGgg=";

  meta = with lib; {
    description = "A generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.unix;
    mainProgram = "vivid";
  };
}
