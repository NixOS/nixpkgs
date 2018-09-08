{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "quicktemplate-unstable-${version}";
  version = "2018-04-30";
  goPackagePath = "github.com/valyala/quicktemplate";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "a91e0946457b6583004fbfc159339b8171423aed";
    sha256 = "1z89ang5pkq5qs5b2nwhzyrw0zjlsas539l9kix374fhka49n8yc";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/valyala/quicktemplate;
    description = "Fast, powerful, yet easy to use template engine for Go";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
