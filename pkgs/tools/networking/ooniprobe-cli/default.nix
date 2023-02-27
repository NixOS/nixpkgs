{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.16.7";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-GebDgdz45INM1Sf7T0qDjFeBqRftMHjGLIAWTM/1REY=";
  };

  vendorHash = "sha256-eH+PfclxqgffM/pzIkdl7x+6Ie6UPyUpWkJ7+G5eN/E=";

  subPackages = [ "cmd/ooniprobe" ];

  meta = with lib; {
    description = "The Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
