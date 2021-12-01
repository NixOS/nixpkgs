{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config }:

stdenv.mkDerivation rec {
  pname = "zzuf";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "samhocevar";
    repo = "zzuf";
    rev = "v${version}";
    sha256 = "0li1s11xf32dafxq1jbnc8c63313hy9ry09dja2rymk9mza4x2n9";
  };

  buildInputs = [ autoconf automake libtool pkg-config ];

  preConfigure = "./bootstrap";

  meta = with lib; {
    description = "Transparent application input fuzzer";
    homepage = "http://caca.zoy.org/wiki/zzuf";
    license = licenses.wtfpl;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lihop ];
  };
}
