{ stdenv, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.5.1";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "1vnidc8kaisdyprylsibddpdksm84c6qr528768yvi93crdmddls";
  };

  modRoot = "gopls";
  vendorSha256 = "048qs6ygav8al3sz9vwf6fqaahkr8wr3dj1yd2jhr7c5h30n4rs2";

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
