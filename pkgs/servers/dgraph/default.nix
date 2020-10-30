{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "dgraph";
  version = "20.07.1";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "0vkkzckk6095vkyl5yqhxqbjmvw7jzars8ymgv2zi55n26qzzvf0";
  };

  vendorSha256 = "17bfavirx0lpy6ca86y2gm6kf8m388xbpda65dd2w71csbzbc2mi";

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
