{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, makeWrapper
, gstreamer, gst-plugins-base, gst-plugins-good, gst-plugins-bad, gst-plugins-ugly, gst-libav, libupnp }:

let version = "4f221e6b85abf85957b547436e982d7a501a1718"; in

stdenv.mkDerivation {
  name = "gmrender-resurrect-${version}";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "gmrender-resurrect";
    rev = "${version}";
    sha256 = "1dmdhyz27bh74qmvncfd3kw7zqwnd05bhxcfjjav98z5qrxdygj4";
  };

  preConfigurePhases = "autoconfPhase";

  autoconfPhase = "./autogen.sh";

  buildInputs = [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav libupnp ];
  nativeBuildInputs = [ autoconf automake pkgconfig makeWrapper ];

  postInstall = ''
    for prog in "$out/bin/"*; do
        wrapProgram "$prog" --suffix GST_PLUGIN_SYSTEM_PATH : "${gst-plugins-base}/lib/gstreamer-1.0:${gst-plugins-good}/lib/gstreamer-1.0:${gst-plugins-bad}/lib/gstreamer-1.0:${gst-plugins-ugly}/lib/gstreamer-1.0:${gst-libav}/lib/gstreamer-1.0"
    done
  '';

  meta = with stdenv.lib; {
    description = "Resource efficient UPnP/DLNA renderer, optimal for Raspberry Pi, CuBox or a general MediaServer";
    homepage = https://github.com/hzeller/gmrender-resurrect;
    license = licenses.gpl2;
    platforms = platforms.linux;
    broken = true;
    maintainers = [ maintainers.koral ];
  };
}
