{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "extrace-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "extrace";
    rev = "v${version}";
    sha256 = "0acspj3djspfvgr3ng5b61qws6v2md6b0lc5qkby10mqnfpkvq85";
  };

  makeFlags = "PREFIX=$(out)";

  postInstall = ''
    install -dm755 "$out/share/licenses/extrace/"
    install -m644 LICENSE "$out/share/licenses/extrace/LICENSE"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/leahneukirchen/extrace;
    description = "Trace exec() calls system-wide";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.leahneukirchen ];
  };
}
