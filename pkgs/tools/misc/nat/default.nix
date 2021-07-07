{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nat";
  version = "2.1.14";

  src = fetchFromGitHub {
    owner = "willdoescode";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:0629nfcf43pzkx1rp6k1nr5sdpsjsgrs21f8yc7g20kxlnppc7z3";
  };

  cargoSha256 = "sha256:1kzsh8c1q51bfvpq13a1i74ss9yms4zjw8gxx2fggj69xhpy3pkg";

  meta = with lib; {
    description = "`ls` alternative with useful info and a splash of color art";
    homepage = "https://github.com/willdoescode/nat";
    license = licenses.mit;
    maintainers = [ maintainers.tejasag ];
  };
}
