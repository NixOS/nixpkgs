{ stdenv, fetchFromGitHub, python3Packages, psmisc, sqlite, utillinuxMinimal, which }:

python3Packages.buildPythonApplication rec {
  pname = "s3ql";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    sha256 = "1x0xj8clfs8fdczn8skc2wag5i4z47bsvlczn22iaf20hll1bb2w";
  };

  nativeBuildInputs = with python3Packages; [
    cython
  ];
  buildInputs = [
    sqlite
  ];
  checkInputs = with python3Packages; [
    pytest
  ] ++ [
    which
  ];
  propagatedBuildInputs = with python3Packages; [
    apsw
    cryptography
    defusedxml
    dugong
    google-auth-oauthlib
    google_auth
    llfuse
    requests
    systemd
  ] ++ [
    psmisc # `umount.s3ql` requires `fuser`
    utillinuxMinimal.bin # `umount.s3ql` requires `umount`
  ];

  preBuild = ''
    # http://www.rath.org/s3ql-docs/installation.html#installing-s3ql
    rm ./MANIFEST.in # Build for release
    ${python3Packages.python.interpreter} ./setup.py build_cython build_ext --inplace
  '';

  checkPhase = ''
    HOME=$TMPDIR pytest tests
  '';

  meta = with stdenv.lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://github.com/s3ql/s3ql";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}
