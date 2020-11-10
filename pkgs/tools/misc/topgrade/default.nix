{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "5.9.1";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "17vrnwx8qv2s2m9sj7h4gxxrnppqs9yzjzp8jsyfnpqd66h60wcg";
  };

  cargoSha256 = "1k5lslin5qpmgz1zkz6xazjnapbr0i5r2ifzcz7bdbxwkaaliksd";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 hugoreeves ];
  };
}
