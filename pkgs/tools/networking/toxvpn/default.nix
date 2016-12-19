{ stdenv, fetchFromGitHub, libtoxcore, cmake, jsoncpp, lib, stdenvAdapters, libsodium, systemd, enableDebugging, libcap }:

with lib;

let
  libtoxcoreLocked = stdenv.lib.overrideDerivation libtoxcore (oldAttrs: {
    name = "libtoxcore-2016-09-07";
    src = fetchFromGitHub {
      owner  = "TokTok";
      repo   = "toxcore";
      rev    = "3521898b0cbf398d882496f6382f6c4ea1c23bc1";
      sha256 = "1jvf0v9cqwd4ssj1iarhgsr05qg48v7yvmbnn3k01jy0lqci8iaq";
    };
  });

in stdenv.mkDerivation {
  name = "toxvpn-2016-09-09";

  src = fetchFromGitHub {
    owner  = "cleverca22";
    repo   = "toxvpn";
    rev    = "6e188f26fff8bddc1014ee3cc7a7423f9f344a09";
    sha256 = "1bshc6pzk7z7q7g17cwx9gmlcyzn4szqvdiy0ihbk2xmx9k31c6p";
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
