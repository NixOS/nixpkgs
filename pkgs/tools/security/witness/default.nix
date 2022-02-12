{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "witness";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "testifysec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NnDsiDUTCdjsHVA/mHnB8WRnvwFTzETkWUOd7IgMIWE=";
  };

  vendorSha256 = "sha256-zkLparWJsuqrhOQxxV37dBqt6fwpSinTO+paJkbl+sM=";

  # We only want the witness binary, not the helper utilities for generating docs.
  subPackages = [ "cmd/witness" ];

  meta = with lib; {
    description = "A pluggable framework for software supply chain security. Witness prevents tampering of build materials and verifies the integrity of the build process from source to target";
    homepage = "https://github.com/testifysec/witness";
    license = licenses.asl20;
    maintainers = with maintainers; [ fkautz ];
  };
}
