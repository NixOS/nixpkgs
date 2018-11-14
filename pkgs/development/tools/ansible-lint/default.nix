{ stdenv, fetchFromGitHub, pythonPackages, ansible }:

pythonPackages.buildPythonPackage rec {
  pname = "ansible-lint";
  version = "3.4.23";

  src = fetchFromGitHub {
    owner = "willthames";
    repo = "ansible-lint";
    rev = "v${version}";
    sha256 = "0cnfgxh5m7alzm811hc95jigbca5vc1pf8fjazmsakmhdjyfbpb7";
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
