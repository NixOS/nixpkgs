{ stdenv, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.6.2";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "0hbfxdsbfz044vw8zp223ni6m7gcwqpff4xpjiqmihhgga5849lf";
  };

  modRoot = "gopls";
  vendorSha256 = "0r9bffgi9ainqrl4kraqy71rgwdfcbqmv3srs12h3xvj0w5ya5rz";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 zimbatm ];
  };
}
