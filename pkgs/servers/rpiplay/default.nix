{
  lib,
  stdenv,
  pkg-config,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  wrapGAppsHook3,
  avahi,
  avahi-compat,
  openssl,
  gst_all_1,
  libplist,
}:

stdenv.mkDerivation rec {
  pname = "rpiplay";
  version = "unstable-2021-06-14";

  src = fetchFromGitHub {
    owner = "FD-";
    repo = "RPiPlay";
    rev = "35dd995fceed29183cbfad0d4110ae48e0635786";
    sha256 = "sha256-qe7ZTT45NYvzgnhRmz15uGT/FnGi9uppbKVbmch5B9A=";
  };

  patches = [
    # allow rpiplay to be used with firewall enabled.
    # sets static ports 7000 7100 (tcp) and 6000 6001 7011 (udp)
    (fetchpatch {
      name = "use-static-ports.patch";
      url = "https://github.com/FD-/RPiPlay/commit/2ffc287ba822e1d2b2ed0fc0e41a2bb3d9dab105.patch";
      sha256 = "08dy829gyhyzw2n54zn5m3176cmd24k5hij24vpww5bhbwkbabww";
    })
  ];

  nativeBuildInputs = [
    cmake
    openssl
    libplist
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    avahi
    avahi-compat
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/FD-/RPiPlay";
    description = "An open-source implementation of an AirPlay mirroring server.";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    mainProgram = "rpiplay";
  };
}
