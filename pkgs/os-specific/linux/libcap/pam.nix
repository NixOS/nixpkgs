{stdenv, pam, libcap}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-pam-${libcap.version}";

  inherit (libcap) src;

  buildInputs = [ libcap pam ];

  preConfigure = "cd pam_cap";

  makeFlags = "${libcap.makeFlags} PAM_CAP=yes";
}
