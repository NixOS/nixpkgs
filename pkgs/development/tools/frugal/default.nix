{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
<<<<<<< HEAD
  version = "3.16.27";
=======
  version = "3.16.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ZHDx6xE/apYF05CXtGJxlp2AWfeEAkWi3zloTFFr78M=";
=======
    sha256 = "sha256-fIEHv0xO/dXof6ED99uCC0y8dF9fBkK5FFtvpoIfbKk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = [ "." ];

<<<<<<< HEAD
  vendorHash = "sha256-2+7GQ54AHEF8ukvn/xUAD1eGESo8jO6TlRFPwlEvZ6A=";
=======
  vendorHash = "sha256-vSUyxjVAmOKh4kcNoC25cDZEuparsJ7FDIslzOy8CNo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
