{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "frida-tools";
  version = "12.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jtxn0a43kv9bLcY1CM3k0kf5K30Ne/FT10ohptWNwEU=";
  };

  propagatedBuildInputs = with python3Packages; [
    pygments
    prompt-toolkit
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
