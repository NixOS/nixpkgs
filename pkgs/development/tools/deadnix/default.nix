{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    sha256 = "sha256-vP+NGqZfGbdk/BE5OVYDQQ9ZtwuJitnBHaPmg1X6el8=";
  };

  cargoSha256 = "sha256-jmxaowzbejimpRdwuX3q3HDbZsv5qWpQ3gApAGdR8o0=";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
