{ buildGoPackage
, libtool
, fetchFromGitHub
, lib
}:

buildGoPackage rec{

  pname = "boulder";
  version = "release-2019-10-13";

  goPackagePath = "github.com/letsencrypt/boulder";

  buildInputs = [ libtool ];

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "boulder";
    rev = version;
    sha256 = "0kis23dnjja6jp192rjpv2m9m2zmzfwhs93440nxg354k6fp8jdg";
  };

  meta = {
    homepage = "https://github.com/letsencrypt/boulder";
    description = "An ACME-based CA, written in Go";
    license = [ lib.licenses.mpl20 ];
    maintainers = [ ];
  };

}
