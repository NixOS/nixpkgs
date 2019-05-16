{ stdenv, buildGoPackage, fetchFromGitHub, tetex, makeWrapper }:

with stdenv.lib;

buildGoPackage rec {
  name = "reporter-${version}";
  version = "2.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/IzakMarais/reporter";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "IzakMarais";
    repo = "reporter";
    sha256 = "1zindyypf634l4dd2rsvp67ryz9mmzq779x9d01apd04wivd9yf1";
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
