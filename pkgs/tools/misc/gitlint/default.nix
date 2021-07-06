{ lib
, buildPythonApplication
, fetchFromGitHub
, gitMinimal
, arrow
, click
, sh
, wheel
}:

buildPythonApplication rec {
  pname = "gitlint";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "jorisroovers";
    repo = "gitlint";
    rev = "v${version}";
    sha256 = "sha256-CqmE4V+svSuQAsoX0I3NpUqPU5CQf3fyCHJPrjUjHF4=";
  };

  nativeBuildInputs = [ wheel ];

  propagatedBuildInputs = [
    arrow
    click
    sh
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  checkInputs = [
    gitMinimal
  ];

  meta = {
    description = "Linting for your git commit messages";
    homepage = "http://jorisroovers.github.io/gitlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
