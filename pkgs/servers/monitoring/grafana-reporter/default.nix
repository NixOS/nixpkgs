{ stdenv, buildGoPackage, fetchFromGitHub, tetex, makeWrapper }:

with stdenv.lib;

buildGoPackage rec {
  name = "reporter-${version}";
  version = "2.0.1";
  rev = "v${version}";

  goPackagePath = "github.com/IzakMarais/reporter";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "IzakMarais";
    repo = "reporter";
    sha256 = "0yi7nx8ig5xgkwizddl0gdicnmcdp4qgg1fdxyq04l2y3qs176sg";
  };

  postInstall = ''
    wrapProgram $bin/bin/grafana-reporter \
      --prefix PATH : ${makeBinPath [ tetex ]}
  '';

  meta = {
    description = "PDF report generator from a Grafana dashboard";
    homepage = https://github.com/IzakMarais/reporter;
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler ];
  };
}
