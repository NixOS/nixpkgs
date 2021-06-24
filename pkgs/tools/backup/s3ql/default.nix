{ lib, fetchFromGitHub, python3Packages, sqlite, which }:

python3Packages.buildPythonApplication rec {
  pname = "s3ql";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    sha256 = "1x0xj8clfs8fdczn8skc2wag5i4z47bsvlczn22iaf20hll1bb2w";
  };

  checkInputs = [ which ] ++ (with python3Packages; [ cython pytest ]);
  propagatedBuildInputs = with python3Packages; [
    sqlite apsw pycrypto requests defusedxml dugong llfuse
    cython pytest pytest-catchlog google-auth google-auth-oauthlib
  ];

  preBuild = ''
    ${python3Packages.python.interpreter} ./setup.py build_cython build_ext --inplace
  '';

  checkPhase = ''
    # Removing integration tests
    rm tests/t{4,5,6}_*
    pytest tests
  '';

  meta = with lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://github.com/s3ql/s3ql/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}
