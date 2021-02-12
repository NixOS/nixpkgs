{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m928hy2q8byfpm55nziiz86gcnhdnw3zpj78d8wx0pp318zjbla";
  };

  cargoSha256 = "1ggr41sg6p4ynx6g30hd8sz37pjrz1v9jskdg6m1n3x2qm175jvr";

  meta = with lib; {
    description = "A generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.unix;
  };
}
