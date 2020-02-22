{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.7.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "c083223d8aa66d4fc6801452d291a98540d1ee41557ce3e1754c62e73f7c9738";
  };

  propagatedBuildInputs = with python3Packages; [ pyopenssl requests tldextract ];

  meta = with stdenv.lib; {
    homepage = https://github.com/komuw/sewer;
    description = "ACME client";
    license = licenses.mit;
    maintainers = with maintainers; [ kevincox ];
  };
}
