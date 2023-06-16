{ lib
, python3
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "frogmouth";
  version = "0.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "frogmouth";
    rev = "v${version}";
    hash = "sha256-BgJdcdIgYNZUJLWDgUWIDyiSSAkLdePYus3IYQo/QpY=";
  };

  patches = [
    (fetchpatch {
      name = "require-httpx-0.24.patch";
      url = "https://github.com/Textualize/frogmouth/commit/386c3bf33238cd6780ca87f2ab4088d81c41707d.patch";
      hash = "sha256-eVBELI9dGFxSPbbdeKgvz44F3oVbT+FOeGt/eqViXsI=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    httpx
    textual
    typing-extensions
    xdg
  ];

  pythonRelaxDeps = [
    "httpx"
    "xdg"
  ];

  pythonImportsCheck = [ "frogmouth" ];

  meta = with lib; {
    description = "A Markdown browser for your terminal";
    homepage = "https://github.com/Textualize/frogmouth";
    changelog = "https://github.com/Textualize/frogmouth/blob/${src.rev}/ChangeLog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
