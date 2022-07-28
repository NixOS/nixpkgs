{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "HyFetch";
  version = "1.1.2";

  src = fetchFromGitHub {
    repo = "hyfetch";
    owner = "hykilpikonna";
    rev = "92623417f90f0cf006c0dd2adcf3f24f4308fe0c";
    sha256 = "sha256-26L2qt+RarRf3+L6+mMy/ZJNVBVirKs5oEclEsImtC0=";
  };

  propagatedBuildInputs = with python3Packages; [
    typing-extensions
    setuptools
  ];

  preCheck = ''
    rm -rf hyfetch/color_scale_numpy.py
  '';

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
    maintainers = [
      maintainers.yisuidenghua
    ];

  };
}
