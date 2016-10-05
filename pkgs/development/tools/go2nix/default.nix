{ stdenv, buildGoPackage, go-bindata, goimports, nix-prefetch-git, git, makeWrapper,
  fetchFromGitHub }:

buildGoPackage rec {
  name = "go2nix-${version}";
  version = "1.1.1";
  rev = "v${version}";

  goPackagePath = "github.com/kamilchm/go2nix";

  src = fetchFromGitHub {
    inherit rev;
    owner = "kamilchm";
    repo = "go2nix";
    sha256 = "1idxgn9yf8shw4mq4d7rhf8fvb2s1lli4r4ck0h8ddf1s9q8p63s";
  };

  goDeps = ./deps.nix;

  buildInputs = [ go-bindata goimports makeWrapper ];
  preBuild = ''go generate ./...'';

  postInstall = ''
    wrapProgram $bin/bin/go2nix \
      --prefix PATH : ${nix-prefetch-git}/bin \
      --prefix PATH : ${git}/bin
  '';

  allowGoReference = true;

  meta = with stdenv.lib; {
    description = "Go apps packaging for Nix";
    homepage = https://github.com/kamilchm/go2nix;
    license = licenses.mit;
    maintainers = with maintainers; [ kamilchm ];
  };
}
