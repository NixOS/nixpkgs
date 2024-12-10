{
  lib,
  buildGoPackage,
  fetchFromGitHub,
  tetex,
  makeWrapper,
}:

with lib;

buildGoPackage rec {
  pname = "reporter";
  version = "2.3.1";
  rev = "v${version}";

  goPackagePath = "github.com/IzakMarais/reporter";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "IzakMarais";
    repo = "reporter";
    sha256 = "sha256-lsraJwx56I2Gn8CePWUlQu1qdMp78P4xwPzLxetYUcw=";
  };

  postInstall = ''
    wrapProgram $out/bin/grafana-reporter \
      --prefix PATH : ${makeBinPath [ tetex ]}
  '';

  meta = {
    description = "PDF report generator from a Grafana dashboard";
    mainProgram = "grafana-reporter";
    homepage = "https://github.com/IzakMarais/reporter";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler ];
  };
}
