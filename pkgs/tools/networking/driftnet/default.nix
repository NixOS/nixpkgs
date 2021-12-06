{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, cairo
, giflib
, glib
, gtk2-x11
, libjpeg
, libpcap
, libpng
, libwebsockets
, pkg-config
, libuv
, openssl
}:

stdenv.mkDerivation rec {
  pname = "driftnet";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "deiv";
    repo = "driftnet";
    rev = "v${version}";
    sha256 = "0kd22aqb25kf54jjv3ml8wy8xm7lmbf0xz1wfp31m08cbzsbizib";
  };

  # https://github.com/deiv/driftnet/pull/33
  # remove on version bump from 1.3.0
  patches = [
    (fetchpatch {
      name = "fix-darwin-build";
      url = "https://github.com/deiv/driftnet/pull/33/commits/bef5f3509ab5710161e9e21ea960a997eada534f.patch";
      sha256 = "1b7p9fkgp7dxv965l7q7y632s80h3nnrkaqnak2h0hakwv0i4pvm";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [
    cairo
    giflib
    glib
    gtk2-x11
    libjpeg
    libpcap
    libpng
    libwebsockets
    openssl
    libuv
  ];

  meta = with lib; {
    description = "Watches network traffic, and picks out and displays JPEG and GIF images for display";
    homepage = "https://github.com/deiv/driftnet";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2Plus;
  };
}
