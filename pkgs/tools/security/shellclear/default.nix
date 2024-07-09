{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "shellclear";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "rusty-ferris-club";
    repo = "shellclear";
    rev = "refs/tags/v${version}";
    hash = "sha256-/0pqegVxrqqxaQ2JiUfkkFK9hp+Vuq7eTap052HEcJs=";
  };

  cargoHash = "sha256-vPd1cFfoSkOnXH3zKQUB0zWDzEtao50AUrUzhpZIkgI=";

  meta = with lib; {
    description = "Secure shell history commands by finding sensitive data";
    homepage = "https://github.com/rusty-ferris-club/shellclear";
    changelog = "https://github.com/rusty-ferris-club/shellclear/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
