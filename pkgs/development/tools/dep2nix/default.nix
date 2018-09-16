{ stdenv, fetchFromGitHub, buildGoPackage
, makeWrapper, nix-prefetch-scripts }:

buildGoPackage rec {
  name = "dep2nix-${version}";
  version = "0.0.2";

  goPackagePath = "github.com/nixcloud/dep2nix";

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo = "dep2nix";
    rev = version;
    sha256 = "17csgnd6imr1l0gpirsvr5qg7z0mpzxj211p2nwqilrvbp8zj7vg";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postFixup = ''
    wrapProgram $bin/bin/dep2nix \
      --prefix PATH : ${nix-prefetch-scripts}/bin
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Convert `Gopkg.lock` files from golang dep into `deps.nix`";
    license = licenses.bsd3;
    homepage = https://github.com/nixcloud/dep2nix;
    maintainers = [ maintainers.mic92 ];
  };
}
