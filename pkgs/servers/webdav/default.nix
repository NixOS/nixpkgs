{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "webdav";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    rev = "v${version}";
    sha256 = "sha256-4rgDO1vItmmCRXRiO24MPa9IPzrsfzCWLH6hl6oKkxk=";
  };

  vendorHash = "sha256-az+EasmKitFPWD5JfKaSKZGok/n/dPmIv90RiL750KY=";

  meta = with lib; {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
    mainProgram = "webdav";
  };
}
