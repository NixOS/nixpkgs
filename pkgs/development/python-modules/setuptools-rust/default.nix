{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, semantic-version
, setuptools
, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "0.11.5";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04ea21f1bd029046fb87d098be4d7dc74663a58dd1f9fc6edcf8f3e4123ec4a8";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ semantic-version setuptools toml ];

  meta = with stdenv.lib; {
    description = "Setuptools plugin for Rust support";
    homepage = "https://github.com/PyO3/setuptools-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
