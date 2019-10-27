{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.7.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "16j4npqj3fdj3g2z7nqb0cvvxd85xk20g9c43f3q8a1k5psf1fmq";
  };

  propagatedBuildInputs = with python3Packages; [ pyopenssl requests tldextract ];

  meta = with stdenv.lib; {
    homepage = https://github.com/komuw/sewer;
    description = "ACME client";
    license = licenses.mit;
    maintainers = with maintainers; [ kevincox ];
    platforms = platforms.linux;
  };
}
