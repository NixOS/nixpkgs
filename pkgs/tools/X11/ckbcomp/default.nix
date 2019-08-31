{ stdenv, fetchFromGitLab, perl, xkeyboard_config }:

stdenv.mkDerivation rec {
  name = "ckbcomp-${version}";
  version = "1.193";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "installer-team";
    repo = "console-setup";
    rev = version;
    sha256 = "107nl6vpy4036km3gr9z5f3mq1i6x169v0z0a0ywavj3zjqy23rp";
  };

  buildInputs = [ perl ];

  patchPhase = ''
    substituteInPlace Keyboard/ckbcomp --replace "/usr/share/X11/xkb" "${xkeyboard_config}/share/X11/xkb"
    substituteInPlace Keyboard/ckbcomp --replace "rules = 'xorg'" "rules = 'base'"
  '';

  dontBuild = true;

  installPhase = ''
    install -Dm0555 -t $out/bin Keyboard/ckbcomp
    install -Dm0444 -t $out/share/man/man1 man/ckbcomp.1
  '';

  meta = with stdenv.lib; {
    description = "Compiles a XKB keyboard description to a keymap suitable for loadkeys";
    homepage = https://salsa.debian.org/installer-team/console-setup;
    license = licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ dezgeg ];
    platforms = platforms.unix;
  };
}
