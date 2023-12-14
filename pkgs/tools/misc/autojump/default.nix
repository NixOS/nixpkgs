{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "autojump";
  version = "22.5.3";

  src = fetchFromGitHub {
    owner = "wting";
    repo = "autojump";
    rev = "release-v${version}";
    sha256 = "1rgpsh70manr2dydna9da4x7p8ahii7dgdgwir5fka340n1wrcws";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ python3 ];
  dontBuild = true;
  strictDeps = true;

  installPhase = ''
    python ./install.py -d "$out" -p "" -z "$out/share/zsh/site-functions/"

    chmod +x "$out/etc/profile.d/autojump.sh"
    install -Dt "$out/share/bash-completion/completions/" -m444 "$out/share/autojump/autojump.bash"
    install -Dt "$out/share/fish/vendor_conf.d/" -m444 "$out/share/autojump/autojump.fish"
    install -Dt "$out/share/zsh/site-functions/" -m444 "$out/share/autojump/autojump.zsh"
  '';

  meta = with lib; {
    description = "A `cd' command that learns";
    longDescription = ''
      One of the most used shell commands is “cd”.  A quick survey
      among my friends revealed that between 10 and 20% of all
      commands they type are actually cd commands! Unfortunately,
      jumping from one part of your system to another with cd
      requires to enter almost the full path, which isn’t very
      practical and requires a lot of keystrokes.

      Autojump is a faster way to navigate your filesystem.  It
      works by maintaining a database of the directories you use the
      most from the command line.  The jstat command shows you the
      current contents of the database.  You need to work a little
      bit before the database becomes usable.  Once your database
      is reasonably complete, you can “jump” to a directory by
      typing "j dirspec", where dirspec is a few characters of the
      directory you want to jump to.  It will jump to the most used
      directory whose name matches the pattern given in dirspec.

      Autojump supports tab-completion.
    '';
    homepage = "https://github.com/wting/autojump";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ domenkozar yurrriq ];
  };
}
