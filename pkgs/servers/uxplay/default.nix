{ lib
, stdenv
, pkg-config
, fetchFromGitHub
, fetchpatch
, cmake
, wrapGAppsHook
, avahi
, avahi-compat
, openssl
, gst_all_1
, libplist
}:

stdenv.mkDerivation rec {
  pname = "uxplay";
  version = "1.50";

  src = fetchFromGitHub {
    owner = "FDH2";
    repo = "UxPlay";
    rev = "v${version}";
    sha256 = "sha256-43BCpYh0XtsnI064/ddcz2/Imj399g+bxLlT0BpqLMI=";
  };

  patches = [
    # https://github.com/FDH2/UxPlay/issues/91
    (fetchpatch {
      url = "https://github.com/FDH2/UxPlay/commit/f373fb2edcfb1f4c279e5796cf21e4a865800a71.patch";
      sha256 = "sha256-ENT/sMyPjDdZ4gdxiatYJ/UxuCl+ekk0iQOn8ELDAKQ=";
    })
  ];

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
