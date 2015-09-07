{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-08-25";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "ae89cf0f34de323c4a7c39bfd9b906acc2635a87";
    sha256 = "04i3c4qg5zccl1inr17vgkjrz9zr718m64pbrlw9rvc82fw5g199";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
