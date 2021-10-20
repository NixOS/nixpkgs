{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "goofys";
  version = "unstable-2021-03-26";

  src = fetchFromGitHub {
    owner = "kahing";
    repo = "goofys";
    # Same as v0.24.0 but migrated to Go modules
    rev = "0c993271269b539196330a18716a33fbeeebd624";
    sha256 = "18is5sv2a9wmsm0qpakly988z1qyl2b2hf2105lpxrgl659sf14p";
  };

  vendorSha256 = "15yq0msh9icxd5n2zkkqrlwxifizhpa99d4aznv8clg32ybs61fj";

  subPackages = [ "." ];

  # Tests are using networking
  postPatch = ''
    rm internal/*_test.go
  '';

  meta = {
    homepage = "https://github.com/kahing/goofys";
    description = "A high-performance, POSIX-ish Amazon S3 file system written in Go.";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.adisbladis ];
  };

}
