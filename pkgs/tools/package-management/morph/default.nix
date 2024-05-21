{ buildGoModule, fetchFromGitHub, lib, makeWrapper, openssh }:

buildGoModule rec {
  pname = "morph";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "dbcdk";
    repo = "morph";
    rev = "v${version}";
    hash = "sha256-0CHmjqPxBgALGZYjfJFLoLBnoI0U7oZ8WyCtu1bkzZg=";
  };

  vendorHash = "sha256-KV+djwUYNfD7NqmYkanRVeKj2lAGfMjJhCUSRiC4/yM=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.assetRoot=${placeholder "lib"}"
  ];

  postInstall = ''
    mkdir -p $lib
    cp -v ./data/*.nix $lib
    wrapProgram $out/bin/morph --prefix PATH : ${lib.makeBinPath [ openssh ]};
  '';

  outputs = [ "out" "lib" ];

  meta = with lib; {
    description = "A NixOS host manager written in Golang";
    license = licenses.mit;
    homepage = "https://github.com/dbcdk/morph";
    maintainers = with maintainers; [adamt johanot];
    mainProgram = "morph";
  };
}
