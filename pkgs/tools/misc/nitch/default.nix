{ lib, nimPackages, fetchFromGitHub, fetchpatch }:
nimPackages.buildNimPackage rec {
  pname = "nitch";
  version = "0.1.6";
  nimBinOnly = true;
  src = fetchFromGitHub {
    owner = "unxsh";
    repo = "nitch";
    rev = "42ad6899931dd5e0cec7b021c2b7e383fcc891f3";
    hash = "sha256-QI7CbP0lvvjD+g29FR/YJjuZboZ+PoHynsNbpYC9SvE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/unxsh/nitch/commit/6831cf96144f58c4da298a0bc9b50d33056f6c08.patch";
      sha256 = "sha256-uZUzUBLHBsssNqDxZ0NuTRMN9/gBxIlIiGgQkqCqEFc=";
    })
  ];

  meta = with lib; {
    description = "Incredibly fast system fetch written in nim";
    homepage = "https://github.com/unxsh/nitch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michaelBelsanti ];
    mainProgram = "nitch";
  };
}
