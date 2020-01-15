{ stdenv, python3, fetchFromGitHub }:

let
  inherit (python3.pkgs) buildPythonApplication pytest mock pexpect;
in
buildPythonApplication rec {
  pname = "lesspass-cli";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1mdv0c0fn4d72iigy8hz4s7kf7q3pg4gjjadxwxyjwsalapnsapk";
  };
  sourceRoot = "source/cli";

  # some tests are designed to run against code in the source directory - adapt to run against
  # *installed* code
  postPatch = ''
    for f in tests/test_functional.py tests/test_interaction.py ; do
      substituteInPlace $f --replace "lesspass/core.py" "-m lesspass.core"
    done
  '';

  checkInputs = [ pytest mock pexpect ];
  checkPhase = ''
    mv lesspass lesspass.hidden  # ensure we're testing against *installed* package
    pytest tests
  '';

  meta = with stdenv.lib; {
    description = "Stateless password manager";
    homepage = https://lesspass.com;
    maintainers = with maintainers; [ jasoncarr ];
    license = licenses.gpl3;
  };
}
