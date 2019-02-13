{ stdenv, fetchFromGitHub, pythonPackages, ansible }:

pythonPackages.buildPythonPackage rec {
  pname = "ansible-lint";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "willthames";
    repo = "ansible-lint";
    rev = "v${version}";
    sha256 = "09qixiaqhm6dbl74s1rwxbsg31nr6jjsvr4fxfnxl9ccbxcrpzn2";
  };

  propagatedBuildInputs = with pythonPackages; [ pyyaml six ] ++ [ ansible ];

  checkInputs = [ pythonPackages.nose ];

  postPatch = ''
    patchShebangs bin/ansible-lint
  '';

   preBuild = ''
     export HOME="$TMP"
   '';

  checkPhase = ''
    nosetests test
  '';

  meta = {
    homepage = "https://github.com/willthames/ansible-lint";
    description = "Best practices checker for Ansible";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.sengaya ];
  };
}
