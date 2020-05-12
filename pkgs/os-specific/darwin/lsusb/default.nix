{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  version = "1.0";
  pname = "lsusb";

  src = fetchFromGitHub {
    owner = "jlhonora";
    repo = "lsusb";
    rev = "8a6bd7084a55a58ade6584af5075c1db16afadd1";
    sha256 = "0p8pkcgvsx44dd56wgipa8pzi3298qk9h4rl9pwsw1939hjx6h0g";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8
    install -m 0755 lsusb $out/bin
    install -m 0444 man/lsusb.8 $out/share/man/man8
  '';

  meta = {
    homepage = "https://github.com/jlhonora/lsusb";
    description = "lsusb command for Mac OS X";
    platforms = stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.varunpatro ];
  };
}
