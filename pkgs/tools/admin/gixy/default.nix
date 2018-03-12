{ lib, fetchFromGitHub, python }:

python.pkgs.buildPythonApplication rec {
  pname = "gixy";
  version = "0.1.9";

  # package is only compatible with python 2.7 and 3.5+
  disabled = with python.pkgs; !(pythonAtLeast "3.5" || isPy27);

  # fetching from GitHub because the PyPi source is missing the tests
  src = fetchFromGitHub {
    owner = "yandex";
    repo = "gixy";
    rev = "v${version}";
    sha256 = "11aps8a8xg1nlw36jgrmnaf38imfz2rj67wnlalrrsqb616xipcv";
  };

  postPatch = ''
    sed -ie '/argparse/d' setup.py
  '';

  propagatedBuildInputs = with python.pkgs; [
    cached-property
    ConfigArgParse
    pyparsing
    jinja2
    nose
    six
  ];

  meta = with lib; {
    description = "Nginx configuration static analyzer";
    longDescription = ''
      Gixy is a tool to analyze Nginx configuration.
      The main goal of Gixy is to prevent security misconfiguration and automate flaw detection.
    '';
    homepage = https://github.com/yandex/gixy;
    license = licenses.mpl20;
    maintainers = [ maintainers.willibutz ];
    platforms = platforms.linux;
  };
}
