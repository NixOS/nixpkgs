{ stdenv, pythonPackages, ansible }:

pythonPackages.buildPythonPackage rec {
  pname = "ansible-lint";
  version = "3.4.20";
  doCheck = false;

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1e7f1d5d5ee91b817dedc0b612c2beb5ff44879d592ea17a2eaa6571aa9a2bff";
  };

  propagatedBuildInputs = with pythonPackages; [ pyyaml six ] ++ [ ansible ];

  meta = {
    homepage = "https://github.com/willthames/ansible-lint";
    description = "Best practices checker for Ansible";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.sengaya ];
  };
}
