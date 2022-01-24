{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "b4";
  version = "0.6.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1j904dy9cwxl85k2ngc498q5cdnqwsmw3jibjr1m55w8aqdck68z";
  };

  preConfigure = ''
    substituteInPlace setup.py \
      --replace 'requests~=2.24.0' 'requests~=2.25' \
      --replace 'dnspython~=2.0.0' 'dnspython~=2.1'
  '';

  # tests make dns requests and fails
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    requests
    dnspython
    dkimpy

    # These may be required in the future for other patch attestation features
    #pycryptodomex~=3.9.9
    #PyNaCl
  ];

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/utils/b4/b4.git/about";
    license = licenses.gpl2Only;
    description = "A helper utility to work with patches made available via a public-inbox archive";
    maintainers = with maintainers; [ jb55 ];
  };
}
