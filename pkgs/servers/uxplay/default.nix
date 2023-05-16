{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, libplist
, pkg-config
, wrapGAppsHook
, avahi
, avahi-compat
, gst_all_1
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "uxplay";
  version = "1.65.3";
=======
stdenv.mkDerivation rec {
  pname = "uxplay";
  version = "1.64";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FDH2";
    repo = "UxPlay";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-ghimxgukQHBc0yVSpttF5lEVE6BTf9OL7RWmR5izxCo=";
=======
    rev = "v${version}";
    sha256 = "sha256-zCjAXQMA5QvcpmkSYb9FST4xzK1cjZZDGcBGc1CacVo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace lib/CMakeLists.txt \
      --replace ".a" "${stdenv.hostPlatform.extensions.sharedLibrary}"
    sed -i '/PKG_CONFIG_EXECUTABLE/d' renderers/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    openssl
    libplist
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    avahi
    avahi-compat
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

<<<<<<< HEAD
  meta = {
    description = "AirPlay Unix mirroring server";
    homepage = "https://github.com/FDH2/UxPlay";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.azuwis ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    homepage = "https://github.com/FDH2/UxPlay";
    description = "AirPlay Unix mirroring server";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
