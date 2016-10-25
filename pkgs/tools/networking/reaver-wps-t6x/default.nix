{ stdenv, fetchFromGitHub, libpcap, sqlite, pixiewps }:

stdenv.mkDerivation rec {
  version = "1.5.2";
  name = "reaver-wps-t6x-${version}";

  src = fetchFromGitHub {
    owner = "t6x";
    repo = "reaver-wps-fork-t6x";
    rev = "v${version}";
    sha256 = "0zhlms89ncqz1f1hc22yw9x1s837yv76f1zcjizhgn5h7vp17j4b";
  };

  buildInputs = [ libpcap sqlite pixiewps ];

  prePatch = "cd src";

  preInstall = "mkdir -p $out/bin";

  meta = {
    description = "Online and offline brute force attack against WPS";
    homepage = https://github.com/t6x/reaver-wps-fork-t6x;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainer = stdenv.lib.maintainers.nico202;
  };
}
