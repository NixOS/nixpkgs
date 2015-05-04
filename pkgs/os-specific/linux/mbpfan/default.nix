{ stdenv, lib, fetchFromGitHub, gnugrep, kmod }:

stdenv.mkDerivation rec {
  name = "mbpfan-${version}";
  version = "1.9.0";
  src = fetchFromGitHub {
    owner = "dgraziotin";
    repo = "mbpfan";
    rev = "v${version}";
    sha256 = "15nm1d0a0c0lzxqngrpn2qpsydsmglnn6d20djl7brpsq26j24h9";
  };
  patches = [ ./fixes.patch ];
  postPatch = ''
    substituteInPlace src/main.c \
      --replace '@GREP@' '${gnugrep}/bin/grep' \
      --replace '@LSMOD@' '${kmod}/bin/lsmod'
  '';
  installPhase = ''
    mkdir -p $out/bin $out/etc
    cp bin/mbpfan $out/bin
    cp mbpfan.conf $out/etc
  '';
  meta = with lib; {
    description = "Daemon that uses input from coretemp module and sets the fan speed using the applesmc module";
    homepage = "https://github.com/dgraziotin/mbpfan";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
