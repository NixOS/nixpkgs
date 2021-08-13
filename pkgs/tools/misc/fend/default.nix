{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Oa/o2Jd0rf+fIVQCaCiSh+tI2KINh1Kx3NTVEULQlzI=";
  };

  cargoSha256 = "sha256-iFGw5mkeRGiMWe5wcrEcmH0WlHJ8p1D0rf1mh+1Mo+w=";

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
