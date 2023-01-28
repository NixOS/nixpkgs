{lib, stdenv, fetchFromGitHub, openssl, libpcap, libxcrypt}:

stdenv.mkDerivation rec {
  pname = "asleap";
  version = "unstable-2021-06-20";

  src = fetchFromGitHub {
    owner = "zackw";
    repo = pname;
    rev = "eb3bd42098cba42b65f499c9d8c73d890861b94f";
    sha256 = "sha256-S6jS0cg9tHSfmP6VHyISkXJxczhPx3HDdxT46c+YmE8=";
  };

  buildInputs = [ openssl libpcap libxcrypt ];

  installPhase = ''
    install -Dm755 asleap $out/bin/asleap
    install -Dm755 genkeys $out/bin/genkeys
  '';

  meta = with lib; {
    homepage = "https://github.com/zackw/asleap";
    description = "Recovers weak LEAP and PPTP passwords";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
