{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "6.5.2";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7tgYVxZ4E6qi/HLgfC0ZreHuXgtd3JMg4ENQL50YWr4=";
  };

  cargoSha256 = "sha256-xxJfNFegvtHJno7o54Rqai9DvvffrkxTFci673Yq/NI=";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Br1ght0ne hugoreeves SuperSandro2000 ];
  };
}
