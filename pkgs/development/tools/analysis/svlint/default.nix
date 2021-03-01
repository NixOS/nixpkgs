{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svlint";
    rev = "v${version}";
    sha256 = "sha256-2PYHKJ141RWdUIDAKAFK6IzR4C41bHi/A8lDErSRLnU=";
  };

  cargoSha256 = "sha256-x5wU0Ld4ssRoNqo9graJhjlpel+VdVdkKZMjHFqZsrE=";

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
