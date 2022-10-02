{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svlint";
    rev = "v${version}";
    sha256 = "sha256-BgkzbKRcZkot3qkwPqSE9QkH3A3HNDuLjpFzKsU+Wb0=";
  };

  cargoSha256 = "sha256-HeFh8H7IN3m4HiEH1QbCBROslzVCzYxGIaeyM4K7gcs=";

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
