{ stdenv, lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "piston-cli";
  version = "1.4.3";
  format = "pyproject";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "qvDGVJcaMXUajdUQWl4W1dost8k0PsS9XX/o8uQrtfY=";
  };

  propagatedBuildInputs = with python3Packages; [ rich prompt-toolkit requests pygments pyyaml more-itertools ];

  checkPhase = ''
    $out/bin/piston --help > /dev/null
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^10.1.0"' 'rich = "*"' \
      --replace 'PyYAML = "^5.4.1"' 'PyYAML = "*"'
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Piston api tool";
    homepage = "https://github.com/Shivansh-007/piston-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
