{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "freeze";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "optiv";
    repo = "Freeze";
    rev = "v${version}";
    hash = "sha256-BE5MvCU+NfEccauOdWNty/FwMiWwLttPh7eE9+UzEMY=";
  };

  vendorHash = "sha256-R8kdFweMhAUjJ8zJ7HdF5+/vllbNmARdhU4hOw4etZo=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    mv $out/bin/Freeze $out/bin/freeze
  '';

  meta = with lib; {
    description = "Payload toolkit for bypassing EDRs";
    mainProgram = "freeze";
    homepage = "https://github.com/optiv/Freeze";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
