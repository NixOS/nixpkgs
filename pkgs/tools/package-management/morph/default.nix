{ buildGoPackage, fetchFromGitHub, go-bindata, lib }:

buildGoPackage rec {
  name = "morph-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dbcdk";
    repo = "morph";
    rev = "v${version}";
    sha256 = "0pixm48is9if9d2b4qc5mwwa4lzma6snkib6z2a1d4pmdx1lmpmm";
  };

  goPackagePath = "github.com/dbcdk/morph";
  goDeps = ./deps.nix;

  buildInputs = [ go-bindata ];

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
