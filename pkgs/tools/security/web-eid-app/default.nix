{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, gtest
, pcsclite
, pkg-config
, qmake
, qttranslations
}:

mkDerivation rec {
  pname = "web-eid-app";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "web-eid";
    repo = "web-eid-app";
    rev = "v${version}";
    sha256 = "sha256-ktYToJ8mnDOiqOHf8iEl1CyHkJ4rAn2lbD0ikc2ctXw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtest # required during build of lib/libelectronic-id/lib/libpcsc-cpp
    pcsclite
    qttranslations
  ];

  meta = with lib; {
    description = "signing and authentication operations with smart cards for the Web eID browser extension";
    longDescription = ''
      The Web eID application performs cryptographic digital signing and
      authentication operations with electronic ID smart cards for the Web eID
      browser extension (it is the [native messaging host](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging)
      for the extension). Also works standalone without the extension in command-line
      mode.
    '';
    homepage = "https://github.com/web-eid/web-eid-app";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
    platforms = platforms.linux;
  };
}
