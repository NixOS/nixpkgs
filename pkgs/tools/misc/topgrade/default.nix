{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O2k9eUs+aopwtT/DXYIv9pc9z8W4K6cXUE6diqNDTrg=";
  };

  cargoSha256 = "0rj0bsyqdr8j8vkfgjmagfm071fvbcxh75drxixdq0d8768y1mba";

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
