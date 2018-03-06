{ stdenv, fetchFromGitHub, pythonPackages, ansible }:

pythonPackages.buildPythonPackage rec {
  pname = "ansible-lint";
  version = "3.4.20";

  src = fetchFromGitHub {
    owner = "willthames";
    repo = "ansible-lint";
    rev = "v${version}";
    sha256 = "0wgczijrg5azn2f63hjbkas1w0f5hbvxnk3ia53w69mybk0gy044";
  };

  propagatedBuildInputs = with pythonPackages; [ pyyaml six ] ++ [ ansible ];

  checkInputs = [ pythonPackages.nose ];

  postPatch = ''
    patchShebangs bin/ansible-lint
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
