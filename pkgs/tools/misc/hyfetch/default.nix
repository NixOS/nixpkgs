{ lib
, stdenv
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "HyFetch";
  version = "1.0.7";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-3/6/3EtTqHXTMuRIo2nclIxYSzOFvQegR29OJsKMQU4=";
  };

  propagatedBuildInputs = with python3Packages; [
    typing-extensions
    setuptools
  ];

  doCheck = false;

  meta = with lib; {
    description = "neofetch with pride flags <3";
    longDescription = ''
        HyFetch is a command-line system information tool fork of neofetch.
        HyFetch displays information about your system next to your OS logo
        in ASCII representation. The ASCII representation is then colored in
        the pattern of the pride flag of your choice. The main purpose of
        HyFetch is to be used in screenshots to show other users what
        operating system or distribution you are running, what theme or
        icon set you are using, etc.
    '';
    homepage = "https://github.com/hykilpikonna/HyFetch";
    license = licenses.mit;
    maintainers = with maintainers; [ hykilpikonna ];
    mainProgram = "hyfetch";
  };
}
