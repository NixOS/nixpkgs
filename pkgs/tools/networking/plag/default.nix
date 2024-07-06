{ lib
, stdenv
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  version = "unstable-2021-12-01";
  pname = "plag";

  src = fetchFromGitLab {
    owner = "qratorlabs";
    repo = "plag";
    rev = "d860bc330ce039d1eb1e5e9fd257bd4a0f8ed48b";
    sha256 = "06q2ydix48k3c8k3dqimg7r33g4aq3nyg46g6qajgvafgnfk1r39";
  };

  installPhase = ''
    install -Dm755 plagmax "$out/bin/plagmax"
    install -Dm755 plageq "$out/bin/plaggeq"
  '';

  meta = with lib; {
    description = "Aggregate a list of IPv4 and IPv6 prefixes";
    homepage = "https://gitlab.com/qratorlabs/plag/";
    license = licenses.mit;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.unix;
  };
}
