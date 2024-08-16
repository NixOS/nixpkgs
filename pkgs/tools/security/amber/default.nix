{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  # Renaming it to amber-secret because another package named amber exists
  pname = "amber-secret";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "amber";
    rev = "v${version}";
    sha256 = "sha256-FoERgkyFCZ1nU01LXpzrqz9eJ9a16L/t+9g8jsABHK4=";
  };

  cargoHash = "sha256-Joy+SO1zR78Eh5eK2bxyT0l3hCuLX/J3u/UvN+++6vg=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Manage secret values in-repo via public key cryptography";
    homepage = "https://github.com/fpco/amber";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
    mainProgram = "amber";
  };
}
