{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, git }:

buildGoPackage rec {
  name = "fac-${version}";
  version = "1.0.1";

  goPackagePath = "github.com/mkchoi212/fac";

  src = fetchFromGitHub {
    owner = "mkchoi212";
    repo = "fac";
    rev = "v${version}";
    sha256 = "1j5kip3l3p9qlly03pih905sdz3ncvpj7135jpnfhckbk1s5x9dc";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $bin/bin/fac \
      --prefix PATH : ${git}/bin
  '';

  meta = with stdenv.lib; {
    description = "CUI for fixing git conflicts";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

