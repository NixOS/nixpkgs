{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "inxi-${version}";
  version = "3.0.34-1";

  src = fetchFromGitHub {
    owner = "smxi";
    repo = "inxi";
    rev = version;
    sha256 = "0x2s40lwsan2pk292nspjgyw00f9f5fdfmwfvl50924pxhyxn2fh";
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
