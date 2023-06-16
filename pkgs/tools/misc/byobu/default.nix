{ lib, stdenv, fetchurl, makeWrapper
, ncurses, python3, perl, textual-window-manager
, gettext, vim, bc, screen }:

let
  pythonEnv = python3.withPackages (ps: with ps; [ snack ]);
in
stdenv.mkDerivation rec {
  version = "5.133";
  pname = "byobu";

  src = fetchurl {
    url = "https://launchpad.net/byobu/trunk/${version}/+download/byobu_${version}.orig.tar.gz";
    sha256 = "0qvmmdnvwqbgbhn5c8asmrmjhclcl029py2d2zvmd7h5ij7s93jd";
  };

  doCheck = true;

  strictdeps = true;
  nativeBuildInputs = [ makeWrapper gettext ];
  buildInputs = [ perl ]; # perl is needed for `lib/byobu/include/*` scripts
  propagatedBuildInputs = [ textual-window-manager screen ];

  postPatch = ''
    substituteInPlace usr/bin/byobu-export.in \
      --replace "gettext" "${gettext}/bin/gettext"
    substituteInPlace usr/lib/byobu/menu \
      --replace "gettext" "${gettext}/bin/gettext"
  '';

  postInstall = ''
    # Byobu does not compile its po files for some reason
    for po in po/*.po; do
      lang=''${po#po/}
      lang=''${lang%.po}
      # Path where byobu looks for translations as observed in the source code and strace
      mkdir -p $out/share/byobu/po/$lang/LC_MESSAGES/
      msgfmt $po -o $out/share/byobu/po/$lang/LC_MESSAGES/byobu.mo
    done

    # Override the symlinks otherwise they mess with the wrapping
    cp --remove-destination $out/bin/byobu $out/bin/byobu-screen
    cp --remove-destination $out/bin/byobu $out/bin/byobu-tmux

    for i in $out/bin/byobu*; do
      # We don't use the usual ".$package-wrapped" because arg0 within the shebang scripts
      # points to the filename and byobu matches against this to know which backend
      # to start with
      file=".$(basename $i)"
      mv $i $out/bin/$file
      makeWrapper "$out/bin/$file" "$out/bin/$(basename $i)" --argv0 $(basename $i) \
        --set BYOBU_PATH ${lib.escapeShellArg (lib.makeBinPath [ vim bc ])} \
        --set BYOBU_PYTHON "${pythonEnv}/bin/python"
    done
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/byobu/";
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

    license = licenses.gpl3;

    platforms = platforms.unix;
    maintainers = with maintainers; [ qknight berbiche ];
  };
}
