{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    sha256 = "1fyagp6m6adwfcisi1zvs5dflcvrmpx4q1fr8pqzb93zv4m3ar84";
  };

  cargoSha256 = "102akpvs2hvf5hl9rh5cspxzqly68wk7qhx0g1zhfp1ka58gnr4p";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
