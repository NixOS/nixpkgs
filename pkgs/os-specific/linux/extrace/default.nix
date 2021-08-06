{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "extrace";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "extrace";
    rev = "v${version}";
    sha256 = "sha256-Kg5yzVg9sqlOCzAq/HeFUPZ89Enfkt/r7EunCfOqdA0=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    install -dm755 "$out/share/licenses/extrace/"
    install -m644 LICENSE "$out/share/licenses/extrace/LICENSE"
  '';

  meta = with lib; {
    homepage = "https://github.com/leahneukirchen/extrace";
    description = "Trace exec() calls system-wide";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.leahneukirchen ];
  };
}
