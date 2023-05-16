{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, gtest
, pcsclite
, pkg-config
<<<<<<< HEAD
, qttools
=======
, qmake
, qttranslations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation rec {
  pname = "web-eid-app";
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "web-eid";
    repo = "web-eid-app";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-xWwguxs/121BFF1zhb/HxS9b1vTwQRemhPKOfHEXVZQ=";
=======
    sha256 = "sha256-X6/vfCDEGXFn05DUSyy7koGVxUAPJ0lv8dnTaoansKk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
<<<<<<< HEAD
    qttools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    gtest # required during build of lib/libelectronic-id/lib/libpcsc-cpp
    pcsclite
<<<<<<< HEAD
=======
    qttranslations
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
