{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aaa";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "DomesticMoth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gIOlPjZOcmVLi9oOn4gBv6F+3Eq6t5b/3fKzoFqxclw=";
  };
  cargoSha256 = "sha256-ugB0r9qiGRurc30GrJH4MKM6fWZ99+f1Gy7/1lSmrwU=";

  meta = with lib; {
    description = "Terminal viewer for 3a format";
    homepage = "https://github.com/DomesticMoth/aaa";
    license = with licenses; [ gpl3Only ];
<<<<<<< HEAD
    maintainers = with maintainers; [ asciimoth ];
=======
    maintainers = with maintainers; [ DomesticMoth ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
