{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ls-lint";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "1.11.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-AlIXZ2tf1pFj6LVz8kyCFq0dUEPBm+0ejQH7VXm4H+M=";
  };

  vendorHash = "sha256-/6Y20AvhUShaE1sNTccB62x8YkVLLjhl6fg5oY4gL4I=";
=======
    sha256 = "sha256-mt1SvRHtAA0lChZ//8XIQGDPg1l1EOMkPIAe8YKhMSs=";
  };

  vendorSha256 = "sha256-OEwN9kj1npI+H7DY+e3tl5TIY/qr4y2CgAV5fwNA9l4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An extremely fast file and directory name linter";
    homepage = "https://ls-lint.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
