{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "passphrase2pgp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VNOoYYnHsSgiSbVxlBwYUq0JsLa4BwZQSvMVSiyB6rg=";
  };

  vendorSha256 = "sha256-7q5nwkj4TP7VgHmV9YBbCB11yTPL7tK4gD+uN4Vw3Cs=";

  postInstall = ''
    mkdir -p $out/share/doc/$name
    cp README.md $out/share/doc/$name
  '';

  meta = with lib; {
    description = "Predictable, passphrase-based PGP key generator";
    homepage = "https://github.com/skeeto/passphrase2pgp";
    license = licenses.unlicense;
    maintainers = with maintainers; [ kaction ];
  };
}
