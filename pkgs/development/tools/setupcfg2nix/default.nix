{ buildPythonApplication, fetchFromGitHub, lib, setuptools }:

buildPythonApplication rec {
  pname = "setupcfg2nix";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "target";
    repo = "setupcfg2nix";
    rev = version;
    sha256 = "1rj227vxybwp9acwnpwg9np964b1qcw2av3qmx00isnrw5vcps8m";
  };

  meta = {
    description = "Generate nix expressions from setup.cfg for a python package";
    homepage = "https://github.com/target/setupcfg2nix";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.shlevy ];
  };
}
