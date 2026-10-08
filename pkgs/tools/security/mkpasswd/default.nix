{
  lib,
  stdenv,
  whois,
  libxcrypt,
  perl,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "mkpasswd";
  inherit (whois) version src patches;

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [ libxcrypt ];

  inherit (whois) preConfigure;
  buildPhase = "make mkpasswd";
  installPhase = "make install-mkpasswd";

  outputs = [
    "out"
    "man"
  ];

  meta = {
    homepage = "https://packages.qa.debian.org/w/whois.html";
    description = "Overfeatured front-end to crypt, from the Debian whois package";
    mainProgram = "mkpasswd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.unix;
  };
}
