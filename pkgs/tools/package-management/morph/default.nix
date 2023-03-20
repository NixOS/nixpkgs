{ buildGoModule, fetchFromGitHub, lib, makeWrapper, openssh }:

buildGoModule rec {
  pname = "morph";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "dbcdk";
    repo = "morph";
    rev = "v${version}";
    sha256 = "sha256-0CHmjqPxBgALGZYjfJFLoLBnoI0U7oZ8WyCtu1bkzZg=";
  };

  vendorSha256 = "08zzp0h4c4i5hk4whz06a3da7qjms6lr36596vxz0d8q0n7rspr9";

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
    platforms = platforms.unix;
  };
}
