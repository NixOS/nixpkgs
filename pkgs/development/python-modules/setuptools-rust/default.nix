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
  version = "0.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p21sw77197m7pciy8g25bwwaakq1675h0x1lis9sypzr46p2s11";
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
