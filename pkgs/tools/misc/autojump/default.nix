{ fetchurl, stdenv, python }:

let version = "4"; in
  stdenv.mkDerivation rec {
    name = "autojump-${version}";

    src = fetchurl {
      url = "http://github.com/joelthelion/autojump/tarball/release-v4";
      name = "autojump-${version}.tar.gz";
      sha256 = "06hjkdmfhawi6xksangymf9z85ql8d7q0vlcmgsw45vxq7iq1fnp";
    };

    # FIXME: Appears to be broken with Bash 4.0:
    # http://wiki.github.com/joelthelion/autojump/doesnt-seem-to-be-working-with-bash-40 .

    patchPhase = ''
      sed -i "install.sh" \
          -e "s,/usr/,$out/,g ; s,/etc/,/nowhere/,g ; s,sudo,,g"
    '';

    buildInputs = [ python ];

    installPhase = ''
      mkdir -p "$out/bin" "$out/share/man/man1"
      yes no | sh ./install.sh

      mkdir -p "$out/etc/bash_completion.d"
      cp -v autojump.bash "$out/etc/bash_completion.d"

      echo "Bash users: Make sure to source \`$out/etc/bash_completion.d/autojump.bash'"
      echo "to get the \`j' and \`jumpstat' commands."

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

      license = "GPLv3+";
    };
  }
