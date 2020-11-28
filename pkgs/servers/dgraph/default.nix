{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "dgraph";
  version = "20.07.2";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "0cx2qqn8b7v0qvhrwzjqghymm8r2a0v86pyfgqxmmyfghjhykax4";
  };

  vendorSha256 = "111lixpqp8p2q4kg9342220i00dcp2lwp2j3hasdvwdrrf0971by";

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
