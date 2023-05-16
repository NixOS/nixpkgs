{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gotestfmt";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gotesttools";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7mLn2axlHoXau9JtLhk1zwzhxkFGHgYPo7igI+IAsP4=";
=======
    hash = "sha256-Rb/nIsHISzvqd+jJU4TNrHbailvgGEq4y0JuM9IdA3w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  meta = with lib; {
    description = "Go test output for humans";
    homepage = "https://github.com/gotesttools/gotestfmt";
    changelog = "https://github.com/GoTestTools/gotestfmt/releases/tag/v${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ urandom ];
  };
}
