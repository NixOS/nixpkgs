{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "freeze";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "optiv";
    repo = "Freeze";
    rev = "v${version}";
    hash = "sha256-ySwd7xs9JdJuBvqKC4jI/qA6qVHbYPPUEG7k6joSkRk=";
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
    homepage = "https://github.com/optiv/Freeze";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
