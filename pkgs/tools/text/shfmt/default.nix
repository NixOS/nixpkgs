{ lib, buildGoModule, fetchFromGitHub, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "shfmt";
<<<<<<< HEAD
  version = "3.7.0";
=======
  version = "3.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-5/WGYsmZAFFdONpViRaqjL/KXyOu618A8S/SqcgZoEU=";
  };

  vendorHash = "sha256-V/6wiC0oanytzMGW/lP+t+uz6cMgXRuviDEj7ErQh5k=";
=======
    sha256 = "sha256-hu08TouICK9tg8+QrAUWpzEAkJ1hHJEIz/UXL+jexrQ=";
  };

  vendorSha256 = "sha256-De/8PLio63xn2byfVzGVCdzRwFxzFMy0ftjB+VEBLrQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/shfmt" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles scdoc ];

  postBuild = ''
    scdoc < cmd/shfmt/shfmt.1.scd > shfmt.1
    installManPage shfmt.1
  '';

  meta = with lib; {
    homepage = "https://github.com/mvdan/sh";
    description = "A shell parser and formatter";
    longDescription = ''
      shfmt formats shell programs. It can use tabs or any number of spaces to indent.
      You can feed it standard input, any number of files or any number of directories to recurse into.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ zowoq SuperSandro2000 ];
<<<<<<< HEAD
    mainProgram = "shfmt";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
