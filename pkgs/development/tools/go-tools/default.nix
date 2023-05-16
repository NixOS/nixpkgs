{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
<<<<<<< HEAD
  version = "2023.1.5";
=======
  version = "2023.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-SDVHkB5L8eARNhxiihZIE/GtBQp0QwRHweLKheSgsBE=";
  };

  vendorHash = "sha256-U0GaArt1R95VIItpfB782SYF7XVIm4BJVVlMZm/zo/g=";
=======
    sha256 = "sha256-ZgPRUkvokHwMHWQMjQJ3Uprt+lf2CAv1kmpUI93J0Cs=";
  };

  vendorHash = "sha256-o9UtS6AMgRYuAkOWdktG2Kr3QDBDQTOGSlya69K2br8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  excludedPackages = [ "website" ];

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit smasher164 ];
  };
}
