{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gjo";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "gjo";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-vEk5MZqwAMgqMLjwRJwnbx8nVyF3U2iUz0S3L0GmCh4=";
  };

  vendorHash = null;
=======
    sha256 = "07halr0jzds4rya6hlvp45bjf7vg4yf49w5q60mch05hk8qkjjdw";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Small utility to create JSON objects";
    homepage = "https://github.com/skanehira/gjo";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
