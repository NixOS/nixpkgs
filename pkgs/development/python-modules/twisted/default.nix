{ lib, stdenv
, buildPythonPackage
, pythonOlder
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
, typing-extensions
, pyasn1
, cryptography
, appdirs
, bcrypt
, pynacl
, pyserial
, h2
, priority
, contextvars
}:
buildPythonPackage rec {
  pname = "Twisted";
  version = "22.4.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "sha256-oEeZD1ffrh4L0rffJSbU8W3NyEN3TcEIt4xS8qXxNoA=";
  };

  propagatedBuildInputs = [ zope_interface incremental automat constantly hyperlink pyhamcrest attrs setuptools typing-extensions ];

  passthru.optional-dependencies = rec {
    tls = [ pyopenssl service-identity idna ];
    conch = [ pyasn1 cryptography appdirs bcrypt ];
    conch_nacl = conch ++ [ pynacl ];
    serial = [ pyserial ];
    http2 = [ h2 priority ];
    contextvars = lib.optionals (pythonOlder "3.7") [ contextvars ];
  };

  # Patch t.p._inotify to point to libc. Without this,
  # twisted.python.runtime.platform.supportsINotify() == False
  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace src/twisted/python/_inotify.py --replace \
      "ctypes.util.find_library(\"c\")" "'${stdenv.cc.libc}/lib/libc.so.6'"
  '';

  # Generate Twisted's plug-in cache.  Twisted users must do it as well.  See
  # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
  # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for
  # details.
  postFixup = ''
    $out/bin/twistd --help > /dev/null
  '';

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s src/twisted/test
  '';
  # Tests require network
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/twisted/twisted";
    description = "Twisted, an event-driven networking engine written in Python";
    longDescription = ''
      Twisted is an event-driven networking engine written in Python
      and licensed under the MIT license.
    '';
    license = licenses.mit;
    maintainers = [ ];
  };
}
