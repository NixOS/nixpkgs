{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-diet";
<<<<<<< HEAD
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = "cargo-diet";
    rev = "v${version}";
    hash = "sha256-SuJ1H/2YfSVVigdgLUd9veMClI7ZT7xkkyQ4PfXoQdQ=";
  };

  cargoHash = "sha256-MASftcn3WmB3M6bvmtnK3nlroE8nq9zdkleSEgzA5lk=";
=======
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JzhSTbEf2Yl5cEIb+88y+s8lUN6c1Mir4NYvzAWMZwY=";
  };

  cargoSha256 = "sha256-zW6ec8DHzP6AuNI6fcOQLH03ca+/yjdh56nltSM9pAA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Help computing optimal include directives for your Cargo.toml manifest";
    homepage = "https://github.com/the-lean-crate/cargo-diet";
    changelog = "https://github.com/the-lean-crate/cargo-diet/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
=======
    maintainers = with maintainers; [ figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
