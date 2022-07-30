{ lib, python3, fetchFromGitLab }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "linkedin-matrix";
  version = "0.5.1";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "beeper";
    repo = "linkedin";
    rev = "v${version}";
    sha256 = "sha256-o4EUwkf/6BXL5oFOciyVbYHuVHCIEoZmd4QZjCRWYko=";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    asyncpg
    CommonMark
    linkedin-messaging
    mautrix
    pillow
    prometheus-client
    python-olm
    python_magic
    ruamel-yaml
    systemd
    unpaddedbase64
  ];

  postInstall = ''
    mkdir -p $out/bin

    # Make a little wrapper for running linkedin-matrix with its dependencies
    echo "$linkedinMatrixScript" > $out/bin/linkedin-matrix
    echo "#!/bin/sh
      exec python -m linkedin_matrix \"\$@\"
    " > $out/bin/linkedin-matrix
    chmod +x $out/bin/linkedin-matrix
    wrapProgram $out/bin/linkedin-matrix \
      --prefix PATH : ${lib.makeBinPath [ python3 ]} \
      --set PYTHONPATH "$PYTHONPATH"
  '';

  pythonImportsCheck = [ "linkedin_matrix" ];

  meta = with lib; {
    description = "A LinkedIn Messaging <-> Matrix bridge.";
    homepage = "https://gitlab.com/beeper/linkedin";
    license = licenses.asl20;
    maintainers = [ maintainers.sumnerevans ];
  };
}
