{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "crlfuzz";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rqhdxOQmZCRtq+IZygKLleb5GoKP2akyEc3rbGcnZmw=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-yLtISEJWIKqCuZtQxReu/Vykw5etqgLpuXqOdtwBkqU=";
=======
  vendorSha256 = "sha256-yLtISEJWIKqCuZtQxReu/Vykw5etqgLpuXqOdtwBkqU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  meta = with lib; {
    description = "Tool to scan for CRLF vulnerability";
    homepage = "https://github.com/dwisiswant0/crlfuzz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
