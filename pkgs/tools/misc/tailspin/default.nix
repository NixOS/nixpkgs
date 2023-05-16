{ lib
<<<<<<< HEAD
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = "refs/tags/${version}";
    hash = "sha256-mtMUHiuGuzLEJk4S+AnpyYGPn0naIP45R9itzXLhG8g=";
  };

  cargoHash = "sha256-M+TUdKtR8/vpkyJiO17LBPDgXq207pC2cUKE7krarfY=";

  meta = with lib; {
    description = "A log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
=======
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tailspin";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = pname;
    rev = version;
    sha256 = "sha256-f9VfOcLOWJ4yr/CS0lqaqiaTfzOgdoI9CaS70AMNdsc=";
  };

  vendorHash = "sha256-gn7/pFw7JEhkkd/PBP4jLUKb5NBaRE/rb049Ic/Bu7A=";

  CGO_ENABLED = 0;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A log file highlighter and a drop-in replacement for `tail -f`";
    homepage = "https://github.com/bensadeh/tailspin";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "spin";
  };
}
