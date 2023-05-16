{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dnsproxy";
<<<<<<< HEAD
  version = "0.54.0";
=======
  version = "0.49.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-wA88v8zF5sq3NQwKh8g4k/COviuaegGn6bBTzBMcdGM=";
=======
    sha256 = "sha256-ImswEptEUUWeHX8hz3L/AJD25xAUAvc17Zli3lYNBjc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" "-X" "main.VersionString=${version}" ];

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ contrun ];
  };
}
