{ lib
, buildPythonApplication
, fetchFromGitHub
, lxml
, setuptools
, six
}:

buildPythonApplication rec {
  pname = "xmldiff";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "Shoobx";
    repo = pname;
    rev = version;
    hash = "sha256-xqudHYfwOce2C0pcFzId0JDIIC6R5bllmVKsH+CvTdE=";
  };

  propagatedBuildInputs = [
    lxml
    setuptools
    six
  ];

  meta = with lib; {
    homepage = "https://xmldiff.readthedocs.io/en/stable/";
    description = "A library and command line utility for diffing xml";
    longDescription = ''
      xmldiff is a library and a command-line utility for making diffs out of
      XML. This may seem like something that doesn't need a dedicated utility,
      but change detection in hierarchical data is very different from change
      detection in flat data. XML type formats are also not only used for
      computer readable data, it is also often used as a format for hierarchical
      data that can be rendered into human readable formats. A traditional diff
      on such a format would tell you line by line the differences, but this
      would not be be readable by a human. xmldiff provides tools to make human
      readable diffs in those situations.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres anpryl ];
  };
}
