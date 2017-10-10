{ stdenv, fetchurl, coreutils, utillinux,
  nettools, bc, which, gnused, gnugrep,
  groff, man-db, getent, libiconv, pcre2,
  gettext, ncurses, python3, fish-foreign-env

  , hostPlatform
  , writeText
  , useOperatingSystemEtc ? true

}:

with stdenv.lib;

let
  etcConfigAppendixText = ''
    ############### ↓ Nix hook for sourcing /etc/fish/config.fish ↓ ###############
    #                                                                             #
    # Origin:
    #     This fish package was called with the attribute
    #     "useOperatingSystemEtc = true;".
    #
    # Purpose:
    #     Fish ordinarily sources /etc/fish/config.fish as
    #        $__fish_sysconfdir/config.fish,
    #     and $__fish_sysconfdir is defined at compile-time, baked into the C++
    #     component of fish. By default, it is set to "/etc/fish". When building
    #     through Nix, $__fish_sysconfdir gets set to $out/etc/fish. Here we may
    #     have included a custom $out/etc/config.fish in the fish package,
    #     as specified, but according to the value of useOperatingSystemEtc, we
    #     may want to further source the real "/etc/fish/config.fish" file.
    #
    #     When this option is enabled, this segment should appear the very end of
    #     "$out/etc/config.fish". This is to emulate the behavior of fish itself
    #     with respect to /etc/fish/config.fish and ~/.config/fish/config.fish:
    #     source both, but source the more global configuration files earlier
    #     than the more local ones, so that more local configurations inherit
    #     from but override the more global locations.

    if test -f /etc/fish/config.fish
      source /etc/fish/config.fish
    end

    #                                                                             #
    ############### ↑ Nix hook for sourcing /etc/fish/config.fish ↑ ###############
  '';


  nixEnvironmentSetupScriptPrefix = "@NIX_STORE@/../var/nix/profiles/default/etc/profile.d";
  selectPosixPreInitScript = if hostPlatform.isDarwin then ''
    # anchor for indentation
        # Use `set -U nix_on_darwin_no_daemon` to tell Fish to use the single-user mode script instead
        if test -f ${nixEnvironmentSetupScriptPrefix}/nix-daemon.sh; and not set -q nix_on_darwin_no_daemon
          fenv source ${nixEnvironmentSetupScriptPrefix}/nix-daemon.sh
        else
          fenv source ${nixEnvironmentSetupScriptPrefix}/nix.sh
        end
  '' else ''
    # anchor for indentation
        test -f ${nixEnvironmentSetupScriptPrefix}/nix.sh
        and fenv source ${nixEnvironmentSetupScriptPrefix}/nix.sh
  '';
  fishPreInitHooks = ''
    # source Nix environment
    # note that this is required:
    #   1. For all shells, not just login shells (mosh needs this as do some other command-line utilities)
    #   2. Before the shell is initialized, so that config snippets can find the commands they use on the PATH
    if builtin status --is-login; or not builtin string length -q $NIX_PROFILES
      # This happens before $__fish_datadir/config.fish sets fish_function_path, so it is currently
      # unset. We set it and then completely erase it, leaving its configuration to $__fish_datadir/config.fish
      set -l original_fish_function_path $fish_function_path
      set fish_function_path ${fish-foreign-env}/share/fish-foreign-env/functions $__fish_datadir/functions

      # If we have a configuration provided by a NixOS or Nix-Darwin administrator, prefer it.
      if test -f /etc/set-environment; and string length -q "$__NIXOS_SET_ENVIRONMENT_DONE"
        fenv source /etc/set-environment
      else
      '' + selectPosixPreInitScript + ''
      end

      # Restore fish_function_path so that it will be correctly set when we
      # return to $__fish_datadir/config.fish (for Nixpkgs' Fish) or the snippet
      # sourcing sequence (for external Fish with, e.g., nix-darwin)
      set fish_function_path $original_fish_function_path
      not builtin string length -q $fish_function_path; and set -e fish_function_path
    end

    if builtin string length -q $NIX_PROFILES
      # We ensure that __extra_* variables are read in $__fish_datadir/config.fish
      # with a preference for user-configured data by making sure the package-specific
      # data comes last. Files are loaded/sourced in encounter order, duplicate
      # basenames get skipped, so we assure this by prepending Nix profile paths
      # (ordered in reverse of the $NIX_PROFILE variable)
      #
      # Note that at this point in evaluation, there is nothing whatsoever on the
      # fish_function_path. That means we don't have most fish builtins, e.g., `eval`.


      # additional profiles are expected in order of precedence, which means the reverse of the
      # NIX_PROFILES variable (same as config.environment.profiles)
      set -l __nix_profile_paths (echo $NIX_PROFILES | ${coreutils}/bin/tr ' ' '\n')[-1..1]

      set __extra_completionsdir \
        $__nix_profile_paths"/etc/fish/completions" \
        $__nix_profile_paths"/share/fish/vendor_completions.d" \
        $__extra_completionsdir
      set __extra_functionsdir \
        $__nix_profile_paths"/etc/fish/functions" \
        $__nix_profile_paths"/share/fish/vendor_functions.d" \
        $__extra_functionsdir
      set __extra_confdir \
        $__nix_profile_paths"/etc/fish/conf.d" \
        $__nix_profile_paths"/share/fish/vendor_conf.d" \
        $__extra_confdir
    end
  '';

  fish = stdenv.mkDerivation rec {
    name = "fish-${version}";
    version = "2.7.1";

    etcConfigAppendix = builtins.toFile "etc-config.appendix.fish" etcConfigAppendixText;

    src = fetchurl {
      # There are differences between the release tarball and the tarball github packages from the tag
      # Hence we cannot use fetchFromGithub
      url = "https://github.com/fish-shell/fish-shell/releases/download/${version}/${name}.tar.gz";
      sha256 = "0nhc3yc5lnnan7zmxqqxm07rdpwjww5ijy45ll2njdc6fnfb2az4";
    };

    buildInputs = [ ncurses libiconv pcre2 ];
    configureFlags = [ "--without-included-pcre2" ];

    # Required binaries during execution
    # Python: Autocompletion generated from manpages and config editing
    propagatedBuildInputs = [
      coreutils gnugrep gnused bc
      python3 groff gettext
    ] ++ optional (!stdenv.isDarwin) man-db;

    postInstall = ''
      sed -r "s|command grep|command ${gnugrep}/bin/grep|" \
          -i "$out/share/fish/functions/grep.fish"
      sed -e "s|bc|${bc}/bin/bc|"                          \
          -e "s|/usr/bin/seq|${coreutils}/bin/seq|"        \
          -i "$out/share/fish/functions/seq.fish"          \
            "$out/share/fish/functions/math.fish"
      sed -i "s|which |${which}/bin/which |"               \
              "$out/share/fish/functions/type.fish"
      sed -e "s|\|cut|\|${coreutils}/bin/cut|"             \
          -i "$out/share/fish/functions/fish_prompt.fish"
      sed -e "s|gettext |${gettext}/bin/gettext |"         \
          -e "s|which |${which}/bin/which |"               \
          -i "$out/share/fish/functions/_.fish"
      sed -e "s|uname|${coreutils}/bin/uname|"             \
          -i "$out/share/fish/functions/__fish_pwd.fish"   \
            "$out/share/fish/functions/prompt_pwd.fish"
      sed -e "s|sed |${gnused}/bin/sed |"                  \
          -i "$out/share/fish/functions/alias.fish"        \
            "$out/share/fish/functions/prompt_pwd.fish"
      sed -i "s|nroff |${groff}/bin/nroff |"               \
            "$out/share/fish/functions/__fish_print_help.fish"
      sed -i "s|/sbin /usr/sbin||" \
            "$out/share/fish/functions/__fish_complete_subcommand_root.fish"
      sed -e "s|clear;|${getBin ncurses}/bin/clear;|" \
          -i "$out/share/fish/functions/fish_default_key_bindings.fish"
      sed -e "s|python3|${getBin python3}/bin/python3|" \
          -i $out/share/fish/functions/{__fish_config_interactive.fish,fish_config.fish,fish_update_completions.fish}

    '' + optionalString stdenv.isLinux ''
      sed -e "s| ul| ${utillinux}/bin/ul|" \
          -i "$out/share/fish/functions/__fish_print_help.fish"
      for cur in $out/share/fish/functions/*.fish; do
        sed -e "s|/usr/bin/getent|${getent}/bin/getent|" \
            -i "$cur"
      done

    '' + optionalString (!stdenv.isDarwin) ''
      sed -i "s|(hostname\||(${nettools}/bin/hostname\||"           \
            "$out/share/fish/functions/fish_prompt.fish"
      sed -i "s|Popen(\['manpath'|Popen(\['${man-db}/bin/manpath'|" \
              "$out/share/fish/tools/create_manpage_completions.py"
      sed -i "s|command manpath|command ${man-db}/bin/manpath|"     \
              "$out/share/fish/functions/man.fish"
    '' + optionalString useOperatingSystemEtc ''
      tee -a $out/etc/fish/config.fish < ${(writeText "config.fish.appendix" etcConfigAppendixText)}
    '' + ''
      # The __nix_preinit_env.fish file is separated out so Nix module systems can tell even
      # non-Nixpkgs Fish to use this logic.
      echo 'source $__fish_datadir/__nix_preinit_env.fish' >> $out/share/fish/__fish_build_paths.fish
      sed -e "s|@NIX_STORE@|$NIX_STORE|" \
             ${(writeText "__nix_preinit_env.fish.in" fishPreInitHooks)} \
             | ${gnugrep}/bin/grep -v 'anchor for indentation' \
             > $out/share/fish/__nix_preinit_env.fish
    '';

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "Smart and user-friendly command line shell";
      homepage = http://fishshell.com/;
      license = licenses.gpl2;
      platforms = platforms.unix;
      maintainers = with maintainers; [ ocharles ];
    };

    passthru = {
      shellPath = "/bin/fish";
    };
  };

  tests = {

    # Test the fish_config tool by checking the generated splash page.
    # Since the webserver requires a port to run, it is not started.
    fishConfig =
      let fishScript = writeText "test.fish" ''
        set -x __fish_bin_dir ${fish}/bin
        echo $__fish_bin_dir
        cp -r ${fish}/share/fish/tools/web_config/* .
        chmod -R +w *
        # we delete everything after the fileurl is assigned
        sed -e '/fileurl =/q' -i webconfig.py
        echo "print(fileurl)" >> webconfig.py
        # and check whether the message appears on the page
        cat (${python3}/bin/python ./webconfig.py \
          | tail -n1 | sed -ne 's|.*\(/tmp/.*\)|\1|p' \
        ) | grep 'a href="http://localhost.*Start the Fish Web config'

        # cannot test the http server because it needs a localhost port
      '';
      in ''
        HOME=$(mktemp -d)
        ${fish}/bin/fish ${fishScript}
      '';
  };

  # FIXME(Profpatsch) replace withTests stub
  withTests = flip const;

in withTests tests fish
