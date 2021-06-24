{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "dgraph";
  version = "20.07.3";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "sha256-yuKXcxewt64T0ToDPid37WUEhwLu+yt4tjhDQobj/Ls=";
  };

  vendorSha256 = "sha256-2Ub0qdEaVSHHE5K0bNSXJFukGeSSXNpIBoUldF8jGpI=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  # see licensing
  buildPhase = ''
    make oss BUILD_VERSION=${version}
  '';

  installPhase = ''
    install dgraph/dgraph -Dt $out/bin

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
    platforms = platforms.unix;
  };
}
