{ buildGoModule
, callPackage
, doCheck ? !stdenv.isDarwin # Can't start localhost test server in MacOS sandbox.
, fetchFromGitHub
, installShellFiles
, lib
, stdenv
}:
let
  version = "23.3.13";
  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "redpanda";
    rev = "v${version}";
    sha256 = "sha256-5JbC9FEF0h9nExrb4IGnc5lzStf7FyQ9imkz6ekRyJg=";
  };
  server = callPackage ./server.nix { inherit src version; };
in
buildGoModule rec {
  pname = "redpanda-rpk";
  inherit doCheck src version;
  modRoot = "./src/go/rpk";
  runVend = false;
  vendorHash = "sha256-B//qmqxS3g9u2yir8Z3iV2fjQ4XXPAjFujeOZjdt8PE=";

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
    description = "Redpanda client";
    homepage = "https://redpanda.com/";
    license = licenses.bsl11;
    maintainers = with maintainers; [ avakhrenev happysalada ];
    platforms = platforms.all;
    mainProgram = "rpk";
  };
}
