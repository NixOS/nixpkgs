<<<<<<< HEAD
{ lib
, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, openssl
, keyutils
, asciidoc
, libxslt
, docbook_xsl
}:
=======
{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, openssl, attr, keyutils, asciidoc, libxslt, docbook_xsl }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "ima-evm-utils";
  version = "1.5";

  src = fetchgit {
    url = "git://git.code.sf.net/p/linux-ima/ima-evm-utils";
    rev = "v${version}";
    sha256 = "sha256-WPBG7v29JHZ+ZGeLgA2gtLzZmaG0Xdvpq+BZ6NriY+A=";
  };

<<<<<<< HEAD
  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    asciidoc
    libxslt
  ];

  buildInputs = [
    openssl
    keyutils
  ];

  env.MANPAGE_DOCBOOK_XSL = "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";
=======
  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ openssl attr keyutils asciidoc libxslt ];

  MANPAGE_DOCBOOK_XSL = "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "evmctl utility to manage digital signatures of the Linux kernel integrity subsystem (IMA/EVM)";
    homepage = "https://sourceforge.net/projects/linux-ima/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ nickcao ];
=======
    maintainers = with lib.maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
