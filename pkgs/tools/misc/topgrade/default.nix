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
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D3yd5Xc+7VNBrRkkKW7BGxEXcZHmmESy2YOEKBf/k9M=";
  };

  cargoSha256 = "sha256-g3Efw8HQ/fvrACyM0sW0bNAVQDdGPLnARe8Uug3szj0=";

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
