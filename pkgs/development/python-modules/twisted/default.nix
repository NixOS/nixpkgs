{ stdenv
, buildPythonPackage
, fetchPypi
, python
, zope_interface
, incremental
, automat
, constantly
, hyperlink
, pyhamcrest
, attrs
, pyopenssl
, service-identity
, setuptools
, idna
, fetchpatch
}:
buildPythonPackage rec {
  pname = "Twisted";
  version = "18.9.0";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "294be2c6bf84ae776df2fc98e7af7d6537e1c5e60a46d33c3ce2a197677da395";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/python-twisted/raw/9248b58fc9b22a159f50759ab4959619dfa04a04/f/0001-Fix-several-request-smuggling-attacks.patch";
      sha256 = "14xx96hiyp5d3w287rpxls8wz49akr4fb1jp5am511j4g9vckb8b";
    })
  ];

  propagatedBuildInputs = [ zope_interface incremental automat constantly hyperlink pyhamcrest attrs setuptools ];

  passthru.extras.tls = [ pyopenssl service-identity idna ];

  # Patch t.p._inotify to point to libc. Without this,
  # twisted.python.runtime.platform.supportsINotify() == False
  patchPhase = stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace src/twisted/python/_inotify.py --replace \
      "ctypes.util.find_library('c')" "'${stdenv.glibc.out}/lib/libc.so.6'"
  '';

  # Generate Twisted's plug-in cache.  Twisted users must do it as well.  See
  # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
  # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for
  # details.
  postInstall = "$out/bin/twistd --help > /dev/null";

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s twisted/test
  '';
  # Tests require network
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://twistedmatrix.com/;
    description = "Twisted, an event-driven networking engine written in Python";
    longDescription = ''
      Twisted is an event-driven networking engine written in Python
      and licensed under the MIT license.
    '';
    license = licenses.mit;
    maintainers = [ ];
  };
}
