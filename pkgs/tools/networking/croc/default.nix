{ lib, buildGoModule, fetchFromGitHub, callPackage }:

buildGoModule rec {
  pname = "croc";
<<<<<<< HEAD
  version = "9.6.5";
=======
  version = "9.6.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-mbDpd2bkNKRhe19f8sLJJnm9DkFWZ12fPqPDGN7pvCc=";
  };

  vendorHash = "sha256-Nw0d/+EQlB0DJRciB2WD0MKZ4HSYY7oSv0ddMPN0CIQ=";
=======
    sha256 = "sha256-ksTKB/UInMHxZT7/B13jVK+w78gUF4KINv2HU1qRPgo=";
  };

  vendorHash = "sha256-d6fsy0ROKX91YkFW2aC2A+pO7dmcmMkoz076z1XcZtE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  passthru = {
    tests = {
      local-relay = callPackage ./test-local-relay.nix { };
    };
  };
  meta = with lib; {
    description = "Easily and securely send things from one computer to another";
    longDescription = ''
      Croc is a command line tool written in Go that allows any two computers to
      simply and securely transfer files and folders.

      Croc does all of the following:
      - Allows any two computers to transfer data (using a relay)
      - Provides end-to-end encryption (using PAKE)
      - Enables easy cross-platform transfers (Windows, Linux, Mac)
      - Allows multiple file transfers
      - Allows resuming transfers that are interrupted
      - Does not require a server or port-forwarding
    '';
    homepage = "https://github.com/schollz/croc";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves equirosa SuperSandro2000 ];
  };
}
