{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
<<<<<<< HEAD
  version = "2.17.0";
=======
  version = "2.16.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6OALbouj1b6Jbtv0znpkfgYS4MyBpxQ56Sen3OJYaHs=";
  };

  vendorHash = "sha256-SjewF3q4vQ3oWR+vxqpZVP6St8db/GXezTDWYUeK2g8=";
=======
    hash = "sha256-7RHRUIZhF6UOZDi85HAzQhzD7c8Y4aPjt4Ly3KUM26k=";
  };

  vendorHash = "sha256-QZzDFVAmmjkm7n/KpMxDMAjShKiVVGZbZB1W3/TeVjs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # The code repository includes other tools which are not useful. Only build
  # hclfmt.
  subPackages = [ "cmd/hclfmt" ];

  meta = with lib; {
    description = "a code formatter for the Hashicorp Configuration Language (HCL) format";
    homepage = "https://github.com/hashicorp/hcl/tree/main/cmd/hclfmt";
    license = licenses.mpl20;
<<<<<<< HEAD
    mainProgram = "hclfmt";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ zimbatm ];
  };
}
