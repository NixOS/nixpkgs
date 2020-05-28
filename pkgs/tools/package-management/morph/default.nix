{ buildGoPackage, fetchFromGitHub, go-bindata, openssh, makeWrapper, lib }:

buildGoPackage rec {
  pname = "morph";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "dbcdk";
    repo = "morph";
    rev = "v${version}";
    sha256 = "064ccvvq4yk17jy5jvi1nxfp5ajvnvn2k4zvh9v0n3ragcl3rd20";
  };

  goPackagePath = "github.com/dbcdk/morph";
  goDeps = ./deps.nix;

  nativeBuildInputs = [ makeWrapper go-bindata ];

  buildFlagsArray = ''
    -ldflags=
    -X
    main.version=${version}
  '';

  postPatch = ''
    go-bindata -pkg assets -o assets/assets.go data/
  '';

  postInstall = ''
    mkdir -p $lib
    cp -v go/src/$goPackagePath/data/*.nix $lib
    wrapProgram $out/bin/morph --prefix PATH : ${lib.makeBinPath [ openssh ]};
  '';

  outputs = [ "out" "lib" ];

  meta = with lib; {
    description = "Morph is a NixOS host manager written in Golang.";
    license = licenses.mit;
    homepage = "https://github.com/dbcdk/morph";
    maintainers = with maintainers; [adamt johanot];
    platforms = platforms.unix;
  };
}
