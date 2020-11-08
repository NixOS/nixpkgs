{ stdenv
, buildPythonPackage
, fetchPypi
, semantic-version
, setuptools
, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "0.11.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9714fcb94c78e6ab1864ddac7750049e105fd4f7c52103aecf40d408e94a722f";
  };

  nativeBuildInputs = [ setuptools_scm ];

  requiredPythonModules = [ semantic-version setuptools toml ];

  meta = with stdenv.lib; {
    description = "Setuptools plugin for Rust support";
    homepage = "https://github.com/PyO3/setuptools-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
