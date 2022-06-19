{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    sha256 = "sha256-a3zEPblkvj9cjGEQB6LKqB+h8C2df7p+IgkwqsUptmY=";
  };

  cargoSha256 = "sha256-zMVXl7kJEavv5zfSm0bTYtd8J3j/LtY3ikPUK2hod+E=";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
