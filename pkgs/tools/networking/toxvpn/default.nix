{ stdenv, fetchFromGitHub, cmake, nlohmann_json,
  libtoxcore, libsodium, libcap, zeromq,
  systemd ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "toxvpn-2018-04-17";

  src = fetchFromGitHub {
    owner  = "cleverca22";
    repo   = "toxvpn";
    rev    = "dc766f98888f500ea51f002f59007eac3f3a0a06";
    sha256 = "19br3fmrdm45fvymj9kvwikkn8m657yd5fkhx6grv35ckrj83mxz";
  };

  buildInputs = [ libtoxcore nlohmann_json libsodium zeromq ]
    ++ optionals stdenv.isLinux [ libcap systemd ];

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
