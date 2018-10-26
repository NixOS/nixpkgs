{ buildPythonPackage
, fetchPypi
, lib
, recursivePthLoader
, pypandoc
}:

buildPythonPackage rec {
  pname = "setuptools-markdown";
  version = "0.2";
  name = "setuptools_markdown";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xzx2krdn2g1kw949mvxkxkc1gflpqmrj9lxdnvdpds3wds66nh6";
  };

  propagatedBuildInputs = [ pypandoc ];
  pythonPath = [ recursivePthLoader ];
  doCheck = false;
  meta = {
    description = "Use Markdown for your project description";
    homepage = https://github.com/msabramo/setuptools-markdown;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfroche ];
  };
}
