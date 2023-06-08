{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "frida-tools";
  version = "12.1.2";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-9SlDyp1fLOzLqu6sxVqY2jwEzQjrnbzfQXIRoyviPJY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pygments
    prompt_toolkit
    colorama
    frida-python
  ];

  meta = {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (client tools)";
    homepage = "https://www.frida.re/";
    maintainers = with lib.maintainers; [ s1341 ];
    license = lib.licenses.wxWindows;
  };
}
