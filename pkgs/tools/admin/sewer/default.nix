{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.7.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "12z4xvblis4xcmm2zbq4dkhjx5lsmcxx80gik2g1pqd2809rxsmy";
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
