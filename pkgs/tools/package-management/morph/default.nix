{ buildGoPackage, fetchFromGitHub, go-bindata, lib }:

buildGoPackage rec {
  pname = "morph";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "dbcdk";
    repo = "morph";
    rev = "v${version}";
    sha256 = "0nwl9n5b0lnil96573wa3hyr3vyvfiwvmpkla3pmwkpmriac4xrg";
  };

  goPackagePath = "github.com/dbcdk/morph";
  goDeps = ./deps.nix;

  buildInputs = [ go-bindata ];

  buildFlagsArray = ''
    -ldflags=
    -X
    main.version=${version}
  '';

  prePatch = ''
    go-bindata -pkg assets -o assets/assets.go data/
  '';

  postInstall = ''
    mkdir -p $lib
    cp -v $src/data/*.nix $lib
  '';

  outputs = [ "out" "bin" "lib" ];

  meta = with lib; {
    description = "Morph is a NixOS host manager written in Golang.";
    license = licenses.mit;
    homepage = "https://github.com/dbcdk/morph";
    maintainers = with maintainers; [adamt johanot];
    platforms = platforms.unix;
  };
}
