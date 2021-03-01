{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dDFc13IVD4f5UgiHXAcqRKoZEPTn/iBOogT3XfdstK0=";
  };

  cargoSha256 = "sha256-QsYOR7tk5cRCF0+xkpJ/F+Z3pjBPxTDFvA1gEi82AOQ=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
