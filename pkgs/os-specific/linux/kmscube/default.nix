{ lib, stdenv, fetchgit, autoreconfHook, libdrm, libX11, libGL, mesa, pkg-config }:

stdenv.mkDerivation {
  pname = "kmscube";
  version = "unstable-2018-06-17";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/mesa/kmscube";
    rev = "9dcce71e603616ee7a54707e932f962cdf8fb20a";
    sha256 = "1q5b5yvyfj3127385mp1bfmcbnpnbdswdk8gspp7g4541xk4k933";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libdrm libX11 libGL mesa ];

  meta = with lib; {
    description = "Example OpenGL app using KMS/GBM";
    homepage = "https://gitlab.freedesktop.org/mesa/kmscube";
    license = licenses.mit;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux;
  };
}
