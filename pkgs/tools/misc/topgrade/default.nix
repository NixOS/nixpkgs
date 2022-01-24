{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2ID3VVT4cQ1yZAD2WVKqkoE7qbe2nNMp1nlwfTxmlZo=";
  };

  cargoSha256 = "sha256-o1V6u7FmP+p+ApL0AmaqTQTZ2f0sZTpx2ro4lR/DFi8=";

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
