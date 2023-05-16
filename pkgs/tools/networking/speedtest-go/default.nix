{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "speedtest-go";
<<<<<<< HEAD
  version = "1.6.6";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "showwin";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-aVvowxwP9Mr1hmcgwizXPfy5527iR7cjsNaND/nmXUw=";
=======
    hash = "sha256-LpsesUC0Cj9pkc/6c0wDEl6X9Y6GqwACwVv7J31TTg0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-wQqAX7YuxxTiMWmV9LRoXunGMMzs12UyHbf4VvbQF1E=";

  excludedPackages = [ "example" ];

  # test suite requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI and Go API to Test Internet Speed using speedtest.net";
    homepage = "https://github.com/showwin/speedtest-go";
    changelog = "https://github.com/showwin/speedtest-go/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
