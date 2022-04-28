{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, Cocoa
, Foundation
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "8.3.1";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EsC17VUQDgrhCU26fsqf2zXOTKa/WeKHiWG0Zn1Qao4=";
  };

  cargoSha256 = "sha256-e5QJw5yY+ZkijqoqRauA5ncvLWiRlalYZCwSG5U7uDk=";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa Foundation ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
    broken = stdenv.isDarwin;
  };
}
