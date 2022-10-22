{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-83ff0T2P5aRQ6cM9z7IEuoi7syvJldIuzzdiTrygckA=";
  };

  cargoSha256 = "sha256-W1tLQTTMOKB/BR9P3y3goPIdOe12Qdkf4wYPlhbQjzY=";

  meta = with lib; {
    description = "A generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.unix;
  };
}
