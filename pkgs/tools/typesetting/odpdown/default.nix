{ stdenv, fetchurl, buildPythonApplication, libreoffice, lpod, lxml, mistune, pillow
, pygments
}:

buildPythonApplication rec {

  name = "odpdown-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/thorstenb/odpdown/archive/v${version}.tar.gz";
    sha256 = "005eecc73c65b9d4c09532547940718a7b308cd565f62a213dfa040827d4d565";
  };

  propagatedBuildInputs = [ libreoffice lpod lxml mistune pillow pygments ];

  meta = with stdenv.lib; {
    homepage = https://github.com/thorstenb/odpdown;
    repositories.git = https://github.com/thorstenb/odpdown.git;
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
