{ stdenv, buildGoPackage, fetchFromGitHub, fetchurl, makeWrapper, git }:

buildGoPackage rec {
  name = "fac-${version}";
  version = "1.1.0";

  goPackagePath = "github.com/mkchoi212/fac";

  src = fetchFromGitHub {
    owner = "mkchoi212";
    repo = "fac";
    rev = "v${version}";
    sha256 = "054j8yrblf1frcfn3dwrjbgf000i3ngbaz2c172nwbx75g309ihx";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $bin/bin/fac \
      --prefix PATH : ${git}/bin

    # Install man page, not installed by default
    install -D go/src/${goPackagePath}/assets/doc/fac.1 $out/share/man/man1/fac.1
  '';

  meta = with stdenv.lib; {
    description = "CUI for fixing git conflicts";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

