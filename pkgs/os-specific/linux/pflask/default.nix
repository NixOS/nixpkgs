{ lib, stdenv, fetchurl, python, waf }:

stdenv.mkDerivation rec {
  name = "pflask-${version}";
  version = "git-2015-12-17";
  rev = "599418bb6453eaa0ccab493f9411f13726c1a636";

  src = fetchurl {
    url = "https://github.com/ghedo/pflask/archive/${rev}.tar.gz";
    sha256 = "2545fca37f9da484b46b6fb5e3a9bbba6526a9725189fe4af5227ef6e6fca440";
  };

  buildInputs = [ python ];

  configurePhase = ''
    ln -s ${waf} waf
    python waf configure --prefix=$out
  '';
  buildPhase = ''
    python waf build
  '';
  installPhase = ''
    python waf install
  '';

  meta = {
    description = "Lightweight process containers for Linux";
    homepage    = "https://ghedo.github.io/pflask/";
    license     = lib.licenses.bsd2;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
