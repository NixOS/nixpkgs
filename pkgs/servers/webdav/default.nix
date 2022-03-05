{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "webdav";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    rev = "v${version}";
    sha256 = "0jnh1bhc98vcx2vm6hmgak6zwfc0rx898qcdjcca5y9dni4120aq";
  };

  vendorSha256 = "19nhz6z8h4fxpy4gjx7zz69si499jak7qj9yb17x32lar5m88gvb";

  meta = with lib; {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
  };
}
