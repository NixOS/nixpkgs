{ buildGoModule
, callPackage
, doCheck ? !stdenv.isDarwin # Can't start localhost test server in MacOS sandbox.
, fetchFromGitHub
, installShellFiles
, lib
, stdenv
}:
let
<<<<<<< HEAD
  version = "23.1.13";
=======
  version = "23.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "redpanda";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-32/mj1/PeeTrtN9COh/hTL4zFcpLnsS0R2uTGpyMUNk=";
=======
    sha256 = "sha256-RiGHEJnvNaNFdTSyabnHAB6n1hpL1T0zOZNCV8w8Pe8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  server = callPackage ./server.nix { inherit src version; };
in
buildGoModule rec {
  pname = "redpanda-rpk";
  inherit doCheck src version;
  modRoot = "./src/go/rpk";
  runVend = false;
  vendorHash = "sha256-8HEJm7m5VgCanV+TY7g00uBUTaWsdv1mxpohmyicjlY=";

  ldflags = [
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/version.version=${version}"''
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/version.rev=v${version}"''
    ''-X "github.com/redpanda-data/redpanda/src/go/rpk/pkg/cli/cmd/container/common.tag=v${version}"''
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/rpk generate shell-completion $shell > rpk.$shell
      installShellCompletion rpk.$shell
    done
  '';

  passthru = {
    inherit server;
  };

  meta = with lib; {
<<<<<<< HEAD
    broken = true;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Redpanda client";
    homepage = "https://redpanda.com/";
    license = licenses.bsl11;
    maintainers = with maintainers; [ avakhrenev happysalada ];
    platforms = platforms.all;
  };
}
