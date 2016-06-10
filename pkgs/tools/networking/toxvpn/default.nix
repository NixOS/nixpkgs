{ stdenv, fetchFromGitHub, libtoxcore, cmake, jsoncpp, lib, stdenvAdapters, libsodium, systemd, enableDebugging, libcap }:

with lib;

let
  libtoxcoreLocked = stdenv.lib.overrideDerivation libtoxcore (oldAttrs: {
    name = "libtoxcore-20160319";
    src = fetchFromGitHub {
      owner  = "irungentoo";
      repo   = "toxcore";
      rev = "532629d486e3361c7d8d95b38293cc7d61dc4ee5";
      sha256 = "0x8mjrjiafgia9vy7w4zhfzicr2fljx8xgm2ppi4kva2r2z1wm2f";
    };
  });

in stdenv.mkDerivation {
  name = "toxvpn-20160606";

  src = fetchFromGitHub {
    owner  = "cleverca22";
    repo   = "toxvpn";
    rev    = "50a0a439a6b11579bab7cc0744a18a9addc5eb5c";
    sha256 = "12dkvsqs4fljwa1367jzqaynf6i8c98y9fs2lm2mqp3wkw0r3rg9";
  };

  buildInputs = [ cmake libtoxcoreLocked jsoncpp libsodium libcap ] ++ optional (systemd != null) systemd;

  cmakeFlags = optional (systemd != null) [ "-DSYSTEMD=1" ];

  meta = with stdenv.lib; {
    description = "A powerful tool that allows one to make tunneled point to point connections over Tox";
    homepage    = https://github.com/cleverca22/toxvpn;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ cleverca22 obadz ];
    platforms   = platforms.linux;
  };
}
