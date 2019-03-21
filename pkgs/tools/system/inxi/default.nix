{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "inxi-${version}";
  version = "3.0.32-1";

  src = fetchFromGitHub {
    owner = "smxi";
    repo = "inxi";
    rev = version;
    sha256 = "171xdip2alkp3g0k0sanaavvdcz6d0wlldj9lgj11xsdbhaaknnv";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp inxi $out/bin/
    mkdir -p $out/share/man/man1
    cp inxi.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "A full featured CLI system information tool";
    homepage = https://smxi.org/docs/inxi.htm;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
