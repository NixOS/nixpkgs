{ stdenv, buildGoPackage, fetchFromGitHub, fetchurl, makeWrapper, git }:

let
  # TODO: Remove this on next update, should be included
  fac_1 = fetchurl {
    url = https://raw.githubusercontent.com/mkchoi212/fac/0a500c2a2dba9017fe7c2a45f15c328755f561a6/doc/fac.1;
    sha256 = "1fsyx9i20ryhpihdpvs2z7vccl13b9bnh5hcdxn7bvqjz78mbqhw";
  };
in buildGoPackage rec {
  name = "fac-${version}";
  version = "1.0.4";

  goPackagePath = "github.com/mkchoi212/fac";

  src = fetchFromGitHub {
    owner = "mkchoi212";
    repo = "fac";
    rev = "v${version}";
    sha256 = "0jhx80jbkxfxj95hmdpb9wwwya064xpfkaa218l1lwm3qwfbpk95";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $bin/bin/fac \
      --prefix PATH : ${git}/bin

    install -D ${fac_1} $out/share/man/man1/fac.1
  '';

  meta = with stdenv.lib; {
    description = "CUI for fixing git conflicts";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

