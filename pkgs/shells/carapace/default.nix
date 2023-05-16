{ lib, buildGoModule, fetchFromGitHub, testers, carapace }:

buildGoModule rec {
  pname = "carapace";
<<<<<<< HEAD
  version = "0.27.0";
=======
  version = "0.24.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UcJbWOYkNUJEilJL/LG5o+I1ugqEOEGfs+uvKUMnTMU=";
  };

  vendorHash = "sha256-PN8ARsJQqRj333ervoy24PZoWkrCIYiGxOovzEhPNZQ=";
=======
    sha256 = "sha256-UEvmaUr/3Fq92HSfBPxSpfuo5mp5zMSYGZu2HLZvUq0=";
  };

  vendorHash = "sha256-4Q8yBDds2EIxt5Caxoq8hk4X6ADwVe04P3Jt3L+Qf0M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    go generate ./...
  '';

  passthru.tests.version = testers.testVersion { package = carapace; };

  meta = with lib; {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://rsteube.github.io/carapace-bin/";
    maintainers = with maintainers; [ star-szr ];
    license = licenses.mit;
<<<<<<< HEAD
    mainProgram = "carapace";
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
