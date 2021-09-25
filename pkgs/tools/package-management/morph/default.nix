{ buildGoModule, fetchFromGitHub, go-bindata, openssh, makeWrapper, lib }:

buildGoModule rec {
  pname = "morph";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dbcdk";
    repo = "morph";
    rev = "v${version}";
    sha256 = "0aibs4gsb9pl21nd93bf963kdzf0661qn0liaw8v8ak2xbz7nbs8";
  };

  vendorSha256 = "08zzp0h4c4i5hk4whz06a3da7qjms6lr36596vxz0d8q0n7rspr9";

  nativeBuildInputs = [ makeWrapper go-bindata ];

  ldflags = [
    "-X main.version=${version}"
  ];

  postPatch = ''
    go-bindata -pkg assets -o assets/assets.go data/
  '';

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
