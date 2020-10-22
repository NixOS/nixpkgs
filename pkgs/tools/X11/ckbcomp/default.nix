{ stdenv, fetchFromGitLab, perl, xkeyboard_config }:

stdenv.mkDerivation rec {
  pname = "ckbcomp";
  version = "1.197";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "installer-team";
    repo = "console-setup";
    rev = version;
    sha256 = "0m2q30f94vd1wb2zqpiyplpgfchjlm8j41xiyxcqdjzdgqbs7l27";
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
    homepage = "https://salsa.debian.org/installer-team/console-setup";
    license = licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ dezgeg ];
    platforms = platforms.unix;
  };
}
