{ lib, fetchFromGitHub, python2Packages, libreoffice }:

python2Packages.buildPythonApplication rec {

  pname = "odpdown";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "thorstenb";
    repo = "odpdown";
    rev = "v${version}";
    sha256 = "r2qbgD9PAalbypt+vjp2YcYggUGPQMEG2FDxMtohqG4=";
  };

  propagatedBuildInputs = with python2Packages; [ libreoffice lpod lxml mistune pillow pygments ];

  checkInputs = with python2Packages; [
    nose
  ];

  meta = with lib; {
    homepage = "https://github.com/thorstenb/odpdown";
    repositories.git = "https://github.com/thorstenb/odpdown.git";
    description = "Create nice-looking slides from your favourite text editor";
    longDescription = ''
      Have a tool like pandoc, latex beamer etc, that you can write (or
      auto-generate) input for within your favourite hacker's editor, and
      generate nice-looking slides from. Using your corporation's mandatory,
      CI-compliant and lovely-artsy Impress template. Including
      syntax-highlighted code snippets of your latest hack, auto-fitted into the
      slides.
    '';
    license = licenses.bsd3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ vandenoever ];
  };
}
