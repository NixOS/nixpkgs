{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2jj5sWnkc8Jl9Hdm9NqtA0icg/4busXTn5bsqW2u8es=";
  };

  cargoSha256 = "sha256-7+BdljkmaT/09PUIa10rZ5Ox2VRZR40zoauDzVxMjQM=";

  doInstallCheck = true;

  installCheckPhase = ''
    [[ "$($out/bin/fend "1 km to m")" = "1000 m" ]]
  '';

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
