{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "sewer";
  version = "0.6.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "180slmc2zk4mvjqp25ks0j8kd63ai4y77ds5icm7qd7av865rryp";
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
