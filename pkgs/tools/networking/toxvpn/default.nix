{ stdenv, fetchFromGitHub, cmake, nlohmann_json,
libtoxcore, libsodium, systemd, libcap, zeromq }:

with stdenv.lib;

let
  systemdOrNull = if stdenv.system == "x86_64-darwin" then null else systemd;
  if_systemd = optional (systemdOrNull != null);
in stdenv.mkDerivation rec {
  name = "toxvpn-${version}";
  version = "2017-06-25";

  src = fetchFromGitHub {
    owner  = "cleverca22";
    repo   = "toxvpn";
    rev    = "7bd6f169d69c511affa8c9672e8f794e4e205a44";
    sha256 = "1km8hkrxmrnca1b49vbw5kyldayaln5plvz78vhf8325r6c5san0";
  };

  buildInputs = [ libtoxcore nlohmann_json libsodium zeromq ]
    ++ if_systemd systemd
    ++ optional (stdenv.system != "x86_64-darwin") libcap;
  nativeBuildInputs = [ cmake ];

  cmakeFlags = optional stdenv.isLinux [ "-DSYSTEMD=1" ];

  postInstall = "$out/bin/toxvpn -h";

  meta = with stdenv.lib; {
    description = "A powerful tool that allows one to make tunneled point to point connections over Tox";
    homepage    = https://github.com/cleverca22/toxvpn;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ cleverca22 obadz ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
