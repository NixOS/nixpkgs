{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "dgraph";
  version = "20.03.4";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "1i098wimzwna62q4wp8ipx8qjrmhrdv48kklm1jdi2sfiz18c9sc";
  };

  vendorSha256 = "0n442nsa2whwb22dl0cjxspl8dc00rqv29zivcw9liwdzara81bw";

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
