{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gomapenum";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "GoMapEnum";
    rev = "v${version}";
    sha256 = "sha256-a0JpHk5pUe+MkcmJl871JwkOfFDg3S4yOzFIeXCReLE=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-5C0dDY/42H8oHNdQaKYiuqpi2QqqgHC7VMO/0kFAofY=";
=======
  vendorSha256 = "sha256-5C0dDY/42H8oHNdQaKYiuqpi2QqqgHC7VMO/0kFAofY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  meta = with lib; {
    description = "Tools for user enumeration and password bruteforce";
    homepage = "https://github.com/nodauf/GoMapEnum";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
