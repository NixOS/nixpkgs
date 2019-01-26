{ fetchFromGitHub, lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  name = "vim-vint-${version}";
  version = "0.3.19";

  src = fetchFromGitHub {
    owner = "kuniwak";
    repo = "vint";
    rev = "v${version}";
    sha256 = "0fb0vkmn5fv4mwk6riw08hb3vsh1pivvrfwm90b95yhksq4pfi12";
  };

  # For python 3.5 > version > 2.7 , a nested dependency (pythonPackages.hypothesis) fails.
  disabled = ! pythonAtLeast "3.5";

  # Prevent setup.py from adding dependencies in run-time and insisting on specific package versions
  patchPhase = ''
    substituteInPlace setup.py --replace "return requires" "return []"
    '';
  buildInputs = [ coverage pytest pytestcov ];
  propagatedBuildInputs = [ ansicolor chardet pyyaml ] ;

  # The acceptance tests check for stdout and location of binary files, which fails in nix-build.
  checkPhase = ''
    py.test -k "not acceptance"
  '';

  meta = with lib; {
    description = "Fast and Highly Extensible Vim script Language Lint implemented by Python";
    homepage = https://github.com/Kuniwak/vint;
    license = licenses.mit;
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.all;
  };
}
