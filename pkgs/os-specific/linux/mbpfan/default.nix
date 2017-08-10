{ stdenv, lib, fetchFromGitHub, fetchpatch, gnugrep, kmod }:

stdenv.mkDerivation rec {
  name = "mbpfan-${version}";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "dgraziotin";
    repo = "mbpfan";
    rev = "v${version}";
    sha256 = "1iri1py9ym0zz7fcacbf0d9y3i3ay77jmajckchagamkfha16zyp";
  };
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
