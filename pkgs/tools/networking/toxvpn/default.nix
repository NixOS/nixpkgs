{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nlohmann_json,
  libtoxcore,
  libsodium,
  libcap,
  zeromq,
  systemd,
}:

stdenv.mkDerivation {
  pname = "toxvpn";
  version = "unstable-2019-09-09";

  src = fetchFromGitHub {
    owner = "cleverca22";
    repo = "toxvpn";
    rev = "45083dec172ce167f7ed84d571ec2822ebe4d51a";
    sha256 = "193crarrx6q0zd2p6dn67pzv8kngwi440zm1y54njgcz0v3fpxmb";
  };

  buildInputs =
    [
      libtoxcore
      nlohmann_json
      libsodium
      zeromq
    ]
    ++ lib.optionals stdenv.isLinux [
      libcap
      systemd
    ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.isLinux [ "-DSYSTEMD=1" ];

  postInstall = "$out/bin/toxvpn -h";

  meta = with lib; {
    description = "Powerful tool that allows one to make tunneled point to point connections over Tox";
    homepage = "https://github.com/cleverca22/toxvpn";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      cleverca22
      obadz
      toonn
    ];
    platforms = platforms.unix;
  };
}
