{stdenv, pam, libcap}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "cap_pam.so-${libcap.version}";

  inherit (libcap) src;

  buildInputs = [ libcap pam ];

  preConfigure = "cd pam_cap";

  makeFlags = "${libcap.makeFlags} PAM_CAP=yes";

  postInstall = libcap.postinst name;
}
