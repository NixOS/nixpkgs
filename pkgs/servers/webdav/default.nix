{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "webdav";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    rev = "v${version}";
    sha256 = "sha256-6hDMu3IgyQeRSxo1z3TAjrEH/XwdfHvoLVjyVwa0LdU=";
  };

  vendorHash = "sha256-LQePicQUm55c0lzVCF6au2v3BfXvGIJHNn2SpTQEjpU=";

  meta = with lib; {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
    mainProgram = "webdav";
  };
}
