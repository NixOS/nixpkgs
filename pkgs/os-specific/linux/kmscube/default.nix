{ lib, stdenv, fetchgit, fetchpatch, autoreconfHook, libdrm, libX11, libGL, mesa, pkg-config }:

stdenv.mkDerivation {
  pname = "kmscube";
  version = "unstable-2018-06-17";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/mesa/kmscube";
    rev = "9dcce71e603616ee7a54707e932f962cdf8fb20a";
    sha256 = "1q5b5yvyfj3127385mp1bfmcbnpnbdswdk8gspp7g4541xk4k933";
  };

  patches = [
    # Pull upstream patch for -fno-common toolchains.
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://gitlab.freedesktop.org/mesa/kmscube/-/commit/908ef39864442c0807954af5d3f88a3da1a6f8a5.patch";
      sha256 = "1gxn3b50mvjlc25234839v5z29r8fd9di4176a3yx4gbsz8cc5vi";
    })
  ];

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
