{ lib, buildGoModule, fetchFromGitHub, installShellFiles, jemalloc, nodejs }:

buildGoModule rec {
  pname = "dgraph";
<<<<<<< HEAD
  version = "23.1.0";
=======
  version = "22.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-AC/5ykNH2eb6IrZ3KlU0DTP4r8RiHE5iUZFCUn6H2cw=";
  };

  vendorHash = "sha256-YRfFRCCm25zS+tQer6UcrBBltOxA7+Iqi+Ejyrjdu/A=";
=======
    sha256 = "sha256-c4gNkT1N1yPotDhRjZvuVvO5TTaL2bqR5I+Z2PcvW10=";
  };

  vendorSha256 = "sha256-K2Q2QBP6fJ3E2LEmZO2U/0DiQifrJVG0lcs4pO5yqrY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [
    "-X github.com/dgraph-io/dgraph/x.dgraphVersion=${version}-oss"
  ];

  tags = [
    "oss"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # todo those dependencies are required in the makefile, but verify how they are used
  # actually
  buildInputs = [ jemalloc nodejs ];

  subPackages = [ "dgraph" ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/dgraph completion $shell > dgraph.$shell
      installShellCompletion dgraph.$shell
    done
  '';

  meta = with lib; {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    maintainers = with maintainers; [ sigma ];
    # Apache 2.0 because we use only build "oss"
    license = licenses.asl20;
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
