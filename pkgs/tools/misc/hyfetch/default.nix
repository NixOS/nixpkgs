{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hyfetch";
  version = "1.4.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = "hyfetch";
    rev = "refs/tags/${version}";
    hash = "sha256-xzN/tbS5BUvpKeozesE99gNp3NRDjvf4Qx7BHLc4svo=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    typing-extensions
    setuptools
  ];

  # No test available
  doCheck = false;

  pythonImportsCheck = [
    "hyfetch"
  ];

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
    mainProgram = "hyfetch";
    maintainers = with maintainers; [ yisuidenghua ];
  };
}
