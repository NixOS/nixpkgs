{ stdenv, lib, fetchFromGitHub, fetchpatch, gnugrep, kmod }:

stdenv.mkDerivation rec {
  name = "mbpfan-${version}";
  version = "2.0.2";
  src = fetchFromGitHub {
    owner = "dgraziotin";
    repo = "mbpfan";
    rev = "v${version}";
    sha256 = "1l8fj92jxfp0sldvznsdsm3pn675b35clq3371h6d5wk4jx67fvg";
  };
  installPhase = ''
    mkdir -p $out/bin $out/etc
    cp bin/mbpfan $out/bin
    cp mbpfan.conf $out/etc
  '';
  meta = with lib; {
    description = "Daemon that uses input from coretemp module and sets the fan speed using the applesmc module";
    homepage = https://github.com/dgraziotin/mbpfan;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
