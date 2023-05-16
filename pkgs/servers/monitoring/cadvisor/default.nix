{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cadvisor";
<<<<<<< HEAD
  version = "unstable-2023-07-28";
=======
  version = "0.46.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
<<<<<<< HEAD
    rev = "fdd3d9182bea6f7f11e4f934631c4abef3aa0584";
    hash = "sha256-U6oZ80EYx56FJ7VsDKzCXH4TvFEH+oPmgK/Nd8T/Zp4=";
=======
    rev = "v${version}";
    sha256 = "sha256-ciGj8SK7OgK3x8Njih4aIQ0vvNV9s5/w2i+DF/vw1O8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  modRoot = "./cmd";

<<<<<<< HEAD
  vendorHash = "sha256-hvgObwmNKk6yTJSyEHuHZ5abuXGPwPC42xUSAAF8UA0=";
=======
  vendorSha256 = "sha256-dg+osxsxdJ8Tg++wdd4L6FMjiPLLFQj0NXb2aSC7vQg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X github.com/google/cadvisor/version.Version=${version}" ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

<<<<<<< HEAD
=======
  preCheck = ''
    rm internal/container/mesos/handler_test.go
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = "https://github.com/google/cadvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
