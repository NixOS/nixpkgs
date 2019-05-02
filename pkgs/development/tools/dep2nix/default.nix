{ stdenv, fetchFromGitHub, buildGoPackage
, makeWrapper, nix-prefetch-scripts }:

buildGoPackage rec {
  pname = "dep2nix";
  version = "unstable-2019-04-02";

  goPackagePath = "github.com/nixcloud/dep2nix";

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo = pname;
    rev = "830684f920333b8ff0946d6b807e8be642eec3ef";
    sha256 = "17sjxhzhmz4893x3x054anp4xvqd1px15nv3fj2m7i6r0vbgpm0j";
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
