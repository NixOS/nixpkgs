{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "extrace";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "extrace";
    rev = "v${version}";
    sha256 = "sha256-Jy/Ac3NcqBkW0kHyypMAVUGAQ41qWM96BbLAym06ogM=";
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
