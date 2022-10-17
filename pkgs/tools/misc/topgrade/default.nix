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
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9zP+rWhaK4fC2Qhd0oq9WVvCkvryooYo09k7016Rbxw=";
  };

  cargoPatches = [ ./darwin-cargo-lock.patch ];
  cargoSha256 = "sha256-rkcEF/INNVn9K4p0/1M++l6lnjtZp1Srx57gkaqcKek=";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa Foundation ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 xyenon ];
  };
}
