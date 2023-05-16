{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9muBKJXsXiSxSmLRygGATEbwpiz6B8oTFQIkVMJMWAk=";
=======
    hash = "sha256-qzi21vouUhvpmqxQpYoCnHJDLRU8ZgCvewxblD2BGJc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace mcfly.bash --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.zsh  --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.fish --replace '(command which mcfly)'  '${placeholder "out"}/bin/mcfly'
  '';

<<<<<<< HEAD
  cargoHash = "sha256-LhIAJ3JI7cp+vzEH5vthefgExPORF6Xnjj3cQkIkhSA=";
=======
  cargoHash = "sha256-RHR+qmtnSrJOPkObRrE39EshmDVu53vEvw647ATk+os=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r where history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/raw/v${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
