{ lib
, fetchFromGitHub
, rustPlatform
<<<<<<< HEAD
, python3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
<<<<<<< HEAD
  version = "0.4.23";
=======
  version = "0.4.22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-LNMc+3pXx7VyNq0dws+s13ZA3+f8aJzgbAxzI71NKx0=";
  };

  cargoHash = "sha256-UjXJmH4UI5Vey2rBy57CI1r13bpGYhIozEoOoyoRDLQ=";

  nativeBuildInputs = [ python3 ];
=======
    sha256 = "sha256-v1fXEC+bV561cewH17x+1anhfXstGBOHG5rHvhYIvLo=";
  };

  cargoSha256 = "sha256-krQTa9R3hmMVKLoBgnbCw+aSQu9HUXfA3XflB8AZv6w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
