{ stdenv, fetchFromGitHub, buildGoPackage
, makeWrapper, nix-prefetch-git }:

buildGoPackage rec {
  name = "dep2nix-${version}";
  version = "0.0.1";

  goPackagePath = "github.com/nixcloud/dep2nix";

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo = "dep2nix";
    rev = version;
    sha256 = "05b06wgcy88fb5ccqwq3mfhrhcblr1akpxgsf44kgbdwf5nzz87g";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postFixup = ''
    wrapProgram $bin/bin/dep2nix \
      --prefix PATH : ${nix-prefetch-git}/bin
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Convert `Gopkg.lock` files from golang dep into `deps.nix`";
    license = licenses.bsd3;
    homepage = https://github.com/nixcloud/dep2nix;
    maintainers = [ maintainers.mic92 ];
  };
}
