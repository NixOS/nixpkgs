{ stdenv, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "s3bro";
  version = "2.8";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0k25g3vch0q772f29jlghda5mjvps55h5lgwhwwbd5g2nlnrrspq";
  };

  propagatedBuildInputs = with python3Packages; [ boto3 botocore click termcolor ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A handy s3 cli tool";
    homepage = https://github.com/rsavordelli/s3bro;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}