{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    sha256 = "0ddnxmcr9fncgrqg1vvqcbx49c3lccdpb40h9rvzyldzy9xynzi7";
  };

  cargoSha256 = "19vgjv70vxgxssrxvdjwfl16bwdbdrpb2wzb3fg9vlz4fhbj2lv9";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
