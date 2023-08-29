{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, gtest
, pcsclite
, pkg-config
, qttools
}:

mkDerivation rec {
  pname = "web-eid-app";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "web-eid";
    repo = "web-eid-app";
    rev = "v${version}";
    sha256 = "sha256-xWwguxs/121BFF1zhb/HxS9b1vTwQRemhPKOfHEXVZQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
  ];

  buildInputs = [
    gtest # required during build of lib/libelectronic-id/lib/libpcsc-cpp
    pcsclite
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
