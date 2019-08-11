{ stdenv, buildGoPackage, go-bindata, gotools, nix-prefetch-git, git, makeWrapper,
  fetchFromGitHub }:

buildGoPackage rec {
  name = "go2nix-${version}";
  version = "1.3.0";
  rev = "v${version}";

  goPackagePath = "github.com/kamilchm/go2nix";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kamilchm";
    repo = "go2nix";
    sha256 = "1q61mgngvyl2bnmrqahh3bji402n76c7xwv29lwk007gymzgff0n";
  };

  goDeps = ./deps.nix;

  outputs = [ "bin" "out" "man" ];

  buildInputs = [ go-bindata gotools makeWrapper ];
  preBuild = ''go generate ./...'';

  postInstall = ''
    wrapProgram $bin/bin/go2nix \
      --prefix PATH : ${nix-prefetch-git}/bin \
      --prefix PATH : ${git}/bin

    mkdir -p $man/share/man/man1
    cp $src/go2nix.1 $man/share/man/man1
  '';

  allowGoReference = true;

  doCheck = false; # tries to access the net

  meta = with stdenv.lib; {
    description = "Go apps packaging for Nix";
    homepage = https://github.com/kamilchm/go2nix;
    license = licenses.mit;
    maintainers = with maintainers; [ kamilchm ];
  };
}
