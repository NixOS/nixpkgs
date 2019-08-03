{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "090mxkmbfzi3mby18zhrr34fr6vzc7j0r2ss3rjr5lyfgilw1qwr";
  };

  modSha256 = "02nkqmljb528ppsr2dw2r3rc83j3qmys3a8v0a1z2b4sq2sv1v7w";

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
