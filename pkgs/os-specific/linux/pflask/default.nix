{ lib, stdenv, fetchurl, python
}:

stdenv.mkDerivation rec {
  name = "pflask-${version}";
  version = "git-2015-10-06";
  rev = "1f575a73d796fbb92e8f2012ded7e97247f1c6c3";

  src = fetchurl {
    url = "https://github.com/ghedo/pflask/archive/${rev}.tar.gz";
    sha256 = "3518aa1e8fa35e059bd63956daed9d8c4115475b66b674d02ebc80484248ddbc";
  };

  buildInputs = [ python ];

  configurePhase = ''
    ln -s ${fetchurl {
      url = "http://ftp.waf.io/pub/release/waf-1.8.6";
      sha256 = "81c4e6a3144c7b2021a839e7277bdaf1cedbbc87302186897b4ae03f4effcbf5";
    }} waf
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
