{ stdenv, fetchFromGitHub, fetchpatch, python3Packages, sqlite, which, psmisc }:

python3Packages.buildPythonApplication rec {
  pname = "s3ql";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    sha256 = "04w8b15mwvyxnq146diblgs83mwsz9m0xmnsss5d1z2vz32i1q3z";
  };

  prePatch = ''
    substituteInPlace src/s3ql/umount.py \
      --replace "'fuser'" "'${psmisc}/bin/fuser'"
  '';

  patches = [
    # Fixes tests with pytest 6, to be removed in next stable version
    (fetchpatch {
      url = "https://github.com/s3ql/s3ql/commit/5316c60b447dbf85a8b80de523fb1a570bf01c11.patch";
      sha256 = "142j8ffhg6w7pf8cpxj0i485fq9vhvac32zjwl9ka4r3fqcq79zb";
    })
  ];

  nativeBuildInputs = with python3Packages; [
    cython
  ];

  propagatedBuildInputs = with python3Packages; [
    sqlite apsw pycrypto requests defusedxml dugong pyfuse3
    google_auth google-auth-oauthlib
  ];

  preBuild = ''
    ${python3Packages.python.interpreter} ./setup.py build_cython build_ext --inplace
  '';

  checkInputs = [ which ] ++ (with python3Packages; [
    pytestCheckHook
    pytest-trio
  ]);

  pytestFlagsArray = [ "tests/" "--ignore-glob='*/t[456]_*'" ];

  meta = with stdenv.lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://github.com/s3ql/s3ql/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}
