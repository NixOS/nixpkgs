{
  buildPythonPackage,
  lib,
  cython,
  libseccomp,
}:

buildPythonPackage rec {
  pname = "libseccomp";
  version = libseccomp.version;
  format = "setuptools";
  src = libseccomp.pythonsrc;

  VERSION_RELEASE = version; # used by build system

  nativeBuildInputs = [ cython ];
  buildInputs = [ libseccomp ];

  unpackCmd = "tar xf $curSrc";
  doInstallCheck = true;

  postPatch = ''
    substituteInPlace ./setup.py \
      --replace 'extra_objects=["../.libs/libseccomp.a"]' \
                'libraries=["seccomp"]'
  '';

  pythonImportsCheck = [ "seccomp" ];

  meta = with lib; {
    description = "Python bindings for libseccomp";
    license = with licenses; [ lgpl21 ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
