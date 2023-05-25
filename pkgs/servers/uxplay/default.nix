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

stdenv.mkDerivation rec {
  pname = "uxplay";
  version = "1.64";

  src = fetchFromGitHub {
    owner = "FDH2";
    repo = "UxPlay";
    rev = "v${version}";
    sha256 = "sha256-zCjAXQMA5QvcpmkSYb9FST4xzK1cjZZDGcBGc1CacVo=";
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

  meta = with lib; {
    homepage = "https://github.com/FDH2/UxPlay";
    description = "AirPlay Unix mirroring server";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azuwis ];
    platforms = platforms.unix;
  };
}
