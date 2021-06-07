{ lib, buildGoModule, fetchFromGitHub, readline }:

buildGoModule rec {
  pname = "hilbish";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Hilbis";
    repo = "Hilbish";
    rev = "v${version}";
    sha256 = "sha256-7YJkjkA6lGyO4PwJcdeUzqQvFsslDfIqAH6vlBtyYz8=";
  };

  vendorSha256 = "sha256-9FftzTn5nxjfsHStcnrn9a+sECmcHRBUEtFjsMp8/ks=";

  buildInputs = [ readline ];

  meta = with lib; {
    description = "An interactive Unix-like shell written in Go";
    changelog = "https://github.com/Hilbis/Hilbish/releases/tag/v${version}";
    homepage = "https://github.com/Hilbis/Hilbish";
    maintainers = with maintainers; [ fortuneteller2k ];
    license = licenses.mit;
    platforms = platforms.linux; # only officially supported on Linux
  };
}
