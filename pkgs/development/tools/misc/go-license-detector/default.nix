{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "go-license-detector";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "go-enry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S9LKXjn5dL5FETOOAk+bs7bIVdu2x7MIhfjpZuXzuLo=";
  };

  vendorHash = "sha256-MtQsUsFd9zQGbP7NGZ4zcSoa6O2WSWvGig0GUwCc6uM=";

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "Reliable project licenses detector";
    homepage = "https://github.com/go-enry/go-license-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "license-detector";
  };
}
