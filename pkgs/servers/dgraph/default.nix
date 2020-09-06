{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "dgraph";
  version = "20.07.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "0jcr3imv6vy40c8zdahsfph5mdxkmp2yqapl5982cf0a61gj7brp";
  };

  vendorSha256 = "0fb8ba2slav6jk93qwaw715myanivrpajfjwi654n0psr57vc7gf";

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
