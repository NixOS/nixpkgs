{ lib, stdenv, pkg-config, fetchFromGitHub, cmake, openssl, gstreamer, gst-plugins-base, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, avahi, avahi-compat, libplist }:

stdenv.mkDerivation rec {
  pname = "uxplay";
  version = "2021-04-27";

  src = fetchFromGitHub {
    owner = "antimof";
    repo = "UxPlay";
    rev = "6a473d6026480c47b6d9f1b2d619039da3cd36ba";
    sha256 = "1qvknydshqivdnljckciiav0lws896nzwyhn852fqwvp1v2h59pb";
  };

  nativeBuildInputs = [
    cmake
    openssl
    libplist
    pkg-config
  ];

  buildInputs = [
    avahi
    avahi-compat
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv uxplay $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "An open-source AirPlay mirroring service";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mschneider ];
    platforms = platforms.unix;
  };
}
