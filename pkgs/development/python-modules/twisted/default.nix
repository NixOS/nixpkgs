{ lib, stdenv
, buildPythonPackage
, fetchpatch
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
}:
buildPythonPackage rec {
  pname = "Twisted";
  version = "22.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "1wml02jxni8k15984pskks7d6yin81w4d2ac026cpyiqd0gjpwsp";
  };

  patches = [
    (fetchpatch {
      # https://github.com/twisted/twisted/security/advisories/GHSA-c2jg-hw38-jrqq
      name = "CVE-2022-24801.patch";
      url = "https://github.com/twisted/twisted/commit/592217e951363d60e9cd99c5bbfd23d4615043ac.patch";
      hash = "sha256-psX5vAM9myuILuTazpebSk8QTT52CB6N7RXAY4MAV8g=";
      excludes = [
        "src/twisted/web/newsfragments/10323.bugfix"
      ];
    })
  ];

  propagatedBuildInputs = [ zope_interface incremental automat constantly hyperlink pyhamcrest attrs setuptools typing-extensions ];

  passthru.extras.tls = [ pyopenssl service-identity idna ];

  # Patch t.p._inotify to point to libc. Without this,
  # twisted.python.runtime.platform.supportsINotify() == False
  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace src/twisted/python/_inotify.py --replace \
      "ctypes.util.find_library(\"c\")" "'${stdenv.glibc.out}/lib/libc.so.6'"
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
