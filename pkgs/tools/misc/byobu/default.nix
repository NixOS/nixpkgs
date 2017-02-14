{ stdenv, fetchurl, makeWrapper, ncurses, python, perl, textual-window-manager,
  gettext, vim, bc}:

let
  pythonEnv = python.withPackages(ps: [ps.snack]);
in stdenv.mkDerivation rec {
  version = "5.115";
  name = "byobu-" + version;

  src = fetchurl {
    url = "https://launchpad.net/byobu/trunk/${version}/+download/byobu_${version}.orig.tar.gz";
    sha256 = "0j2kfqwza2qq8hni87pjn2p722aan3m51wwn4h3vz904n7303g4y";
  };

  doCheck = true;

  buildInputs = [ perl pythonEnv makeWrapper vim bc gettext];

  propagatedBuildInputs = [ textual-window-manager ];

  postUnpack = ''
    substituteInPlace $sourceRoot/usr/bin/byobu-select-profile.in \
      --replace "/bin/true" "true" \
      --replace "gettext" "${gettext}/bin/gettext"
    substituteInPlace $sourceRoot/usr/bin/byobu-export.in \
      --replace "gettext" "${gettext}/bin/gettext"
  '';

  postInstall = ''
    wrapProgram $out/bin/byobu-status-detail --prefix PATH ":" "${vim}/bin/"
    wrapProgram $out/bin/byobu-ulevel --prefix PATH ":" "${bc}/bin/"
    for i in $out/bin/*; do
      wrapProgram "$i" --set BYOBU_PYTHON "${pythonEnv}/bin/python"
    done
  '';

  meta = {
    homepage = https://launchpad.net/byobu/;
    description = "Text-based window manager and terminal multiplexer";

    longDescription =
      ''Byobu is a GPLv3 open source text-based window manager and terminal multiplexer.
        It was originally designed to provide elegant enhancements to the otherwise functional,
        plain, practical GNU Screen, for the Ubuntu server distribution.
        Byobu now includes an enhanced profiles, convenient keybindings,
        configuration utilities, and toggle-able system status notifications for both
        the GNU Screen window manager and the more modern Tmux terminal multiplexer,
        and works on most Linux, BSD, and Mac distributions.
      '';

    license = stdenv.lib.licenses.gpl3;

    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ qknight ryantm ];
  };
}
