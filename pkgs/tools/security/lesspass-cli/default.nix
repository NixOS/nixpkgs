{ lib, python3, fetchFromGitHub }:

let
  inherit (python3.pkgs) buildPythonApplication pytest mock pexpect;
  repo = "lesspass";
in
buildPythonApplication rec {
  pname = "lesspass-cli";
  version = "9.1.9";

  src = fetchFromGitHub {
    owner = repo;
    repo = repo;
    rev = version;
    sha256 = "126zk248s9r72qk9b8j27yvb8gglw49kazwz0sd69b5kkxvhz2dh";
  };
  sourceRoot = "${src.name}/cli";

  # some tests are designed to run against code in the source directory - adapt to run against
  # *installed* code
  postPatch = ''
    for f in tests/test_functional.py tests/test_interaction.py ; do
      substituteInPlace $f --replace "lesspass/core.py" "-m lesspass.core"
    done
  '';

  nativeCheckInputs = [ pytest mock pexpect ];
  checkPhase = ''
    mv lesspass lesspass.hidden  # ensure we're testing against *installed* package
    pytest tests
  '';

  meta = with lib; {
    description = "Stateless password manager";
    mainProgram = "lesspass";
    homepage = "https://lesspass.com";
    maintainers = with maintainers; [ jasoncarr ];
    license = licenses.gpl3;
  };
}
