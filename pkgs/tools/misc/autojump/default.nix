{ fetchurl, stdenv, python, bash }:

let 
  version = "21.5.8";
in
  stdenv.mkDerivation rec {
    name = "autojump-${version}";

    src = fetchurl {
      url = "http://github.com/joelthelion/autojump/archive/release-v${version}.tar.gz";
      name = "autojump-${version}.tar.gz";
      sha256 = "07jf5pa9xwmbswsc0h6law9f5qwczsj25w7h034s379imid5h62f";
    };

    buildInputs = [ python ];
    dontBuild = true;

    installPhase = ''
      bash ./install.sh -d $out

      mkdir -p "$out/etc/bash_completion.d"
      cp -v $out/etc/profile.d/autojump.bash "$out/etc/bash_completion.d"
      mkdir -p $out/bin
      ln -s $out/usr/local/bin/autojump $out/bin/j

      # FIXME: What's the right place for `autojump.zsh'?
    '';

    meta = {
      description = "Autojump, a `cd' command that learns";
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
        bit before the database becomes useable.  Once your database
        is reasonably complete, you can “jump” to a directory by
        typing "j dirspec", where dirspec is a few characters of the
        directory you want to jump to.  It will jump to the most used
        directory whose name matches the pattern given in dirspec.

        Autojump supports tab-completion.
      '';
      homepage = http://wiki.github.com/joelthelion/autojump;
      license = stdenv.lib.licenses.gpl3;
      platforms = stdenv.lib.platforms.all;
      maintainers = [ stdenv.lib.maintainers.iElectric ];
    };
  }
