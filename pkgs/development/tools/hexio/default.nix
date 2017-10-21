{ stdenv, fetchFromGitHub, fetchurl, python, pcsclite, pth }:

stdenv.mkDerivation rec {
  pname = "hexio";
  name = "${pname}-${version}";
  version = "1.0-RC1";

  src = fetchFromGitHub {
    sha256 = "08jxkdi0gjsi8s793f9kdlad0a58a0xpsaayrsnpn9bpmm5cgihq";
    rev = "version-${version}";
    owner = "vanrein";
    repo = "hexio";
  };

  propagatedBuildInputs = [ python ];
  buildInputs = [ pcsclite pth ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace '-I/usr/local/include/PCSC/' '-I${pcsclite}/include/PCSC/' \
      --replace '-L/usr/local/lib/pth' '-I${pth}/lib/'
    '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/sbin $out/man
    make DESTDIR=$out PREFIX=/ all
    make DESTDIR=$out PREFIX=/ install
    '';

  meta = with stdenv.lib; {
    description = "Low-level I/O helpers for hexadecimal, tty/serial devices and so on";
    homepage = https://github.com/vanrein/hexio;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
