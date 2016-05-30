{ stdenv, fetchFromGitHub, libtoxcore, cmake, jsoncpp, lib, stdenvAdapters, libsodium, systemd, enableDebugging, libcap }:

with lib;

let
  libtoxcoreLocked = stdenv.lib.overrideDerivation libtoxcore (oldAttrs: {
    name = "libtoxcore-20151110";
    src = fetchFromGitHub {
      owner  = "irungentoo";
      repo   = "toxcore";
      rev    = "22634a4b93dda5b17cb357cd84ac46fcfdc22519";
      sha256 = "01i92wm5lg2p7k71qn23sfh01xi8acdrwn23rk52n54h424l1fgy";
    };
  });

in stdenv.mkDerivation {
  name = "toxvpn-20151111";

  src = fetchFromGitHub {
    owner  = "cleverca22";
    repo   = "toxvpn";
    rev    = "1d06bb7da277d46abb8595cf152210c4ccf0ba7d";
    sha256 = "1himrbdgsbkfha1d87ysj2hwyz4a6z9yxqbai286imkya84q7r15";
  };

  buildInputs = [ cmake libtoxcoreLocked jsoncpp libsodium systemd libcap ];

  cmakeFlags = [ "-DSYSTEMD=1" ];

  meta = {
    description = "A powerful tool that allows one to make tunneled point to point connections over Tox";
    homepage    = https://github.com/cleverca22/toxvpn;
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
