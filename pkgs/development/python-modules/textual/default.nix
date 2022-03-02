{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, rich
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "textual";
  version = "0.1.15";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jmjais0yq8dwi9yikgrxdw4rwp8aq1981nhfxn0v97jb07i4cj6";
  };

  patches = [
    (fetchpatch {
      # v0.1.15 git tag has 0.1.14 in pyproject.toml
      name = "version.patch";
      url = "https://github.com/Textualize/textual/commit/1b8d7d184e10889002425641222702afba508aea.patch";
      sha256 = "1nfqp5f8ba3fg0ar3lghrlqypbjbsaywxaz3iiff8fy8j2wgsppp";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    rich
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "textual" ];

  meta = with lib; {
    description = "TUI framework for Python inspired by modern web development";
    homepage = "https://github.com/Textualize/textual";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
