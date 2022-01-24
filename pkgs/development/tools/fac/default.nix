{ lib, buildGoPackage, fetchFromGitHub, makeWrapper, git }:

buildGoPackage rec {
  pname = "fac";
  version = "2.0.0";

  goPackagePath = "github.com/mkchoi212/fac";

  src = fetchFromGitHub {
    owner = "mkchoi212";
    repo = "fac";
    rev = "v${version}";
    sha256 = "054bbiw0slz9szy3ap2sh5dy97w3g7ms27rd3ww3i1zdhvnggwpc";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/fac \
      --prefix PATH : ${git}/bin

    # Install man page, not installed by default
    install -D go/src/${goPackagePath}/assets/doc/fac.1 $out/share/man/man1/fac.1
  '';

  meta = with lib; {
    description = "CUI for fixing git conflicts";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

