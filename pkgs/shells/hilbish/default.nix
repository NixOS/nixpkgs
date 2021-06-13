{ lib, buildGoModule, fetchFromGitHub, readline }:

buildGoModule rec {
  pname = "hilbish";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "v${version}";
    sha256 = "sha256-cYpGTk0adT3X/elrJW2Wjv4SbPvgeyYmsOHTrft8678=";
  };

  vendorSha256 = "sha256-8l+Kb1ADMLwv0Hf/ikok8eUcEEST07rhk8BjHxJI0lc=";

  buildInputs = [ readline ];

  meta = with lib; {
    description = "An interactive Unix-like shell written in Go";
    changelog = "https://github.com/Rosettea/Hilbish/releases/tag/v${version}";
    homepage = "https://github.com/Rosettea/Hilbish";
    maintainers = with maintainers; [ fortuneteller2k ];
    license = licenses.mit;
    platforms = platforms.linux; # only officially supported on Linux
  };
}
