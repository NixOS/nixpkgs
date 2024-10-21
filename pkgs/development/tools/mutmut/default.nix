{
  lib,
  fetchFromGitHub,
  mutmut,
  python3Packages,
  testers,
}:

python3Packages.buildPythonApplication rec {
  pname = "mutmut";
  version = "3.0.5";

  src = fetchFromGitHub {
    repo = pname;
    owner = "boxed";
    rev = "refs/tags/${version}";
    hash = "sha256-ZvUO/Cizzavnf81pVvtw8+zHCpqE8qdQb9zEVezYl+M=";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace-fail 'junit-xml==1.8' 'junit-xml==1.9'
  '';

  disabled = python3Packages.pythonOlder "3.7";

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    click
    parso
    junit-xml
    setproctitle
    textual
  ];

  passthru.tests.version = testers.testVersion { package = mutmut; };

  meta = with lib; {
    description = "mutation testing system for Python, with a strong focus on ease of use";
    mainProgram = "mutmut";
    homepage = "https://github.com/boxed/mutmut";
    changelog = "https://github.com/boxed/mutmut/blob/${version}/HISTORY.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
