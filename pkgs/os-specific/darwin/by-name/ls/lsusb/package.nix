{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  version = "1.0";
  pname = "lsusb";

  src = fetchFromGitHub {
    owner = "jlhonora";
    repo = "lsusb";
    rev = "8a6bd7084a55a58ade6584af5075c1db16afadd1";
    hash = "sha256-D0DTJUwjBa75TTQTmCZGSYz4L1I3Pm5Ka4R0vR+bF10=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8
    install -m 0755 lsusb $out/bin
    install -m 0444 man/lsusb.8 $out/share/man/man8
  '';

  meta = {
    homepage = "https://github.com/jlhonora/lsusb";
    description = "Lsusb command for Mac OS X";
    platforms = lib.platforms.darwin;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.varunpatro ];
  };
}
