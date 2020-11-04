{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m3kqk0ghlpzysyql777jlk5c0nb36z44vabw6r0484fh5vncwrh";
  };

  cargoSha256 = "1h5cyiyhpagdin9a8gfsccbl4jahw33nbkg5m74axyp4qrfc1mkz";

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
