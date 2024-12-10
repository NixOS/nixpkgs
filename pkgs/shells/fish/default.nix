{ stdenv
, lib
, fetchurl
, fetchpatch
, coreutils
, which
, gnused
, gnugrep
, groff
, gawk
, man-db
, getent
, libiconv
, pcre2
, gettext
, ncurses
, python3
, cmake
, fishPlugins
, procps

# used to generate autocompletions from manpages and for configuration editing in the browser
, usePython ? true

, runCommand
, writeText
, nixosTests
, nix-update-script
, useOperatingSystemEtc ? true
  # An optional string containing Fish code that initializes the environment.
  # This is run at the very beginning of initialization. If it sets $NIX_PROFILES
  # then Fish will use that to configure its function, completion, and conf.d paths.
  # For example:
  #   fishEnvPreInit = "source /etc/fish/my-env-preinit.fish";
  # It can also be a function that takes one argument, which is a function that
  # takes a path to a bash file and converts it to fish. For example:
  #   fishEnvPreInit = source: source "${nix}/etc/profile.d/nix-daemon.sh";
, fishEnvPreInit ? null
}:
let
  etcConfigAppendix = writeText "config.fish.appendix" ''
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
    #
    #     Special care needs to be taken, when fish is called from an FHS user env
    #     or similar setup, because this configuration file will then be relocated
    #     to /etc/fish/config.fish, so we test for this case to avoid nontermination.

    if test -f /etc/fish/config.fish && test /etc/fish/config.fish != (status filename)
      source /etc/fish/config.fish
    end

    #                                                                             #
    ############### ↑ Nix hook for sourcing /etc/fish/config.fish ↑ ###############
  '';

  fishPreInitHooks = writeText "__fish_build_paths_suffix.fish" ''
    # source nixos environment
    # note that this is required:
    #   1. For all shells, not just login shells (mosh needs this as do some other command-line utilities)
    #   2. Before the shell is initialized, so that config snippets can find the commands they use on the PATH
    builtin status is-login
    or test -z "$__fish_nixos_env_preinit_sourced" -a -z "$ETC_PROFILE_SOURCED" -a -z "$ETC_ZSHENV_SOURCED"
    ${if fishEnvPreInit != null then ''
    and begin
    ${lib.removeSuffix "\n" (if lib.isFunction fishEnvPreInit then fishEnvPreInit sourceWithFenv else fishEnvPreInit)}
    end'' else ''
    and test -f /etc/fish/nixos-env-preinit.fish
    and source /etc/fish/nixos-env-preinit.fish''}
    and set -gx __fish_nixos_env_preinit_sourced 1

    test -n "$NIX_PROFILES"
    and begin
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
      set -l __nix_profile_paths (string split ' ' $NIX_PROFILES)[-1..1]

      set -p __extra_completionsdir \
        $__nix_profile_paths"/etc/fish/completions" \
        $__nix_profile_paths"/share/fish/vendor_completions.d"
      set -p __extra_functionsdir \
        $__nix_profile_paths"/etc/fish/functions" \
        $__nix_profile_paths"/share/fish/vendor_functions.d"
      set -p __extra_confdir \
        $__nix_profile_paths"/etc/fish/conf.d" \
        $__nix_profile_paths"/share/fish/vendor_conf.d"
    end
  '';

  # This is wrapped in begin/end in case the user wants to apply redirections.
  # This does mean the basic usage of sourcing a single file will produce
  # `begin; begin; …; end; end` but that's ok.
  sourceWithFenv = path: ''
    begin # fenv
      # This happens before $__fish_datadir/config.fish sets fish_function_path, so it is currently
      # unset. We set it and then completely erase it, leaving its configuration to $__fish_datadir/config.fish
      set fish_function_path ${fishPlugins.foreign-env}/share/fish/vendor_functions.d $__fish_datadir/functions
      fenv source ${lib.escapeShellArg path}
      set -l fenv_status $status
      # clear fish_function_path so that it will be correctly set when we return to $__fish_datadir/config.fish
      set -e fish_function_path
      test $fenv_status -eq 0
    end # fenv
  '';

  fish = stdenv.mkDerivation rec {
    pname = "fish";
    version = "3.7.1";

    src = fetchurl {
      # There are differences between the release tarball and the tarball GitHub
      # packages from the tag. Specifically, it comes with a file containing its
      # version, which is used in `build_tools/git_version_gen.sh` to determine
      # the shell's actual version (and what it displays when running `fish
      # --version`), as well as the local documentation for all builtins (and
      # maybe other things).
      url = "https://github.com/fish-shell/fish-shell/releases/download/${version}/${pname}-${version}.tar.xz";
      hash = "sha256-YUyfVkPNB5nfOROV+mu8NklCe7g5cizjsRTTu8GjslA=";
    };

    patches = [
      # We don’t want to run `/usr/libexec/path_helper` on nix-darwin,
      # as it pulls in paths not tracked in the system configuration
      # and messes up the order of `$PATH`. Upstream are unfortunately
      # unwilling to accept a change for this and have recommended that
      # it should be a distro‐specific patch instead.
      #
      # See:
      #
      # * <https://github.com/LnL7/nix-darwin/issues/122>
      # * <https://github.com/fish-shell/fish-shell/issues/7142>
      ./nix-darwin-path.patch
    ];

    # Fix FHS paths in tests
    postPatch = ''
      # src/fish_tests.cpp
      sed -i 's|/bin/ls|${coreutils}/bin/ls|' src/fish_tests.cpp
      sed -i 's|is_potential_path(L"/usr"|is_potential_path(L"/nix"|' src/fish_tests.cpp
      sed -i 's|L"/bin/echo"|L"${coreutils}/bin/echo"|' src/fish_tests.cpp
      sed -i 's|L"/bin/c"|L"${coreutils}/bin/c"|' src/fish_tests.cpp
      sed -i 's|L"/bin/ca"|L"${coreutils}/bin/ca"|' src/fish_tests.cpp
      # disable flakey test
      sed -i '/{TEST_GROUP("history_races"), history_tests_t::test_history_races},/d' src/fish_tests.cpp

      # tests/checks/cd.fish
      sed -i 's|/bin/pwd|${coreutils}/bin/pwd|' tests/checks/cd.fish

      # tests/checks/redirect.fish
      sed -i 's|/bin/echo|${coreutils}/bin/echo|' tests/checks/redirect.fish

      # tests/checks/vars_as_commands.fish
      sed -i 's|/usr/bin|${coreutils}/bin|' tests/checks/vars_as_commands.fish

      # tests/checks/jobs.fish
      sed -i 's|ps -o stat|${procps}/bin/ps -o stat|' tests/checks/jobs.fish
      sed -i 's|/bin/echo|${coreutils}/bin/echo|' tests/checks/jobs.fish

      # tests/checks/job-control-noninteractive.fish
      sed -i 's|/bin/echo|${coreutils}/bin/echo|' tests/checks/job-control-noninteractive.fish

      # tests/checks/complete.fish
      sed -i 's|/bin/ls|${coreutils}/bin/ls|' tests/checks/complete.fish
    '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Tests use pkill/pgrep which are currently not built on Darwin
      # See https://github.com/NixOS/nixpkgs/pull/103180
      rm tests/pexpects/exit.py
      rm tests/pexpects/job_summary.py
      rm tests/pexpects/signals.py

      # pexpect tests are flaky in general
      # See https://github.com/fish-shell/fish-shell/issues/8789
      rm tests/pexpects/bind.py
    '' + lib.optionalString stdenv.hostPlatform.isLinux ''
      # pexpect tests are flaky on aarch64-linux (also x86_64-linux)
      # See https://github.com/fish-shell/fish-shell/issues/8789
      rm tests/pexpects/exit_handlers.py
    '';

    outputs = [ "out" "doc" ];
    strictDeps = true;
    nativeBuildInputs = [
      cmake
      gettext
    ];

    buildInputs = [
      ncurses
      libiconv
      pcre2
    ];

    cmakeFlags = [
      "-DCMAKE_INSTALL_DOCDIR=${placeholder "doc"}/share/doc/fish"
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DMAC_CODESIGN_ID=OFF"
    ];

    # Fish’s test suite needs to be able to look up process information and send signals.
    sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
      (allow mach-lookup mach-task-name)
      (allow signal (target children))
    '';

    # The optional string is kind of an inelegant way to get fish to cross compile.
    # Fish needs coreutils as a runtime dependency, and it gets put into
    # CMAKE_PREFIX_PATH, which cmake uses to look up build time programs, so it
    # was clobbering the PATH. It probably needs to be fixed at a lower level.
    preConfigure = ''
      patchShebangs ./build_tools/git_version_gen.sh
    '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      export CMAKE_PREFIX_PATH=
    '';

    # Required binaries during execution
    propagatedBuildInputs = [
      coreutils
      gnugrep
      gnused
      groff
      gettext
    ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) man-db;

    doCheck = true;

    nativeCheckInputs = [
      coreutils
      (python3.withPackages (ps: [ ps.pexpect ]))
      procps
    ];

    checkPhase = ''
      make test
    '';

    postInstall = ''
      sed -r "s|command grep|command ${gnugrep}/bin/grep|" \
          -i "$out/share/fish/functions/grep.fish"
      sed -e "s|\|cut|\|${coreutils}/bin/cut|"             \
          -i "$out/share/fish/functions/fish_prompt.fish"
      sed -e "s|uname|${coreutils}/bin/uname|"             \
          -i "$out/share/fish/functions/__fish_pwd.fish"   \
             "$out/share/fish/functions/prompt_pwd.fish"
      sed -e "s|sed |${gnused}/bin/sed |"                  \
          -i "$out/share/fish/functions/alias.fish"        \
             "$out/share/fish/functions/prompt_pwd.fish"
      sed -i "s|nroff|${groff}/bin/nroff|"                 \
             "$out/share/fish/functions/__fish_print_help.fish"
      sed -e "s|clear;|${lib.getBin ncurses}/bin/clear;|"      \
          -i "$out/share/fish/functions/fish_default_key_bindings.fish"
      sed -i "s|/usr/local/sbin /sbin /usr/sbin||"         \
             $out/share/fish/completions/{sudo.fish,doas.fish}
      sed -e "s| awk | ${gawk}/bin/awk |"                  \
          -i $out/share/fish/functions/{__fish_print_packages.fish,__fish_print_addresses.fish,__fish_describe_command.fish,__fish_complete_man.fish,__fish_complete_convert_options.fish} \
             $out/share/fish/completions/{cwebp,adb,ezjail-admin,grunt,helm,heroku,lsusb,make,p4,psql,rmmod,vim-addons}.fish

    '' + lib.optionalString usePython ''
      cat > $out/share/fish/functions/__fish_anypython.fish <<EOF
      function __fish_anypython
          echo ${python3.interpreter}
          return 0
      end
      EOF

    '' + lib.optionalString stdenv.hostPlatform.isLinux ''
      for cur in $out/share/fish/functions/*.fish; do
        sed -e "s|/usr/bin/getent|${getent}/bin/getent|" \
            -i "$cur"
      done

    '' + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      sed -i "s|Popen(\['manpath'|Popen(\['${man-db}/bin/manpath'|" \
              "$out/share/fish/tools/create_manpage_completions.py"
      sed -i "s|command manpath|command ${man-db}/bin/manpath|"     \
              "$out/share/fish/functions/man.fish"
    '' + lib.optionalString useOperatingSystemEtc ''
      tee -a $out/etc/fish/config.fish < ${etcConfigAppendix}
    '' + ''
      tee -a $out/share/fish/__fish_build_paths.fish < ${fishPreInitHooks}
    '';

    meta = with lib; {
      description = "Smart and user-friendly command line shell";
      homepage = "https://fishshell.com/";
      changelog = "https://github.com/fish-shell/fish-shell/releases/tag/${version}";
      license = licenses.gpl2Only;
      platforms = platforms.unix;
      maintainers = with maintainers; [ adamcstephens cole-h winter sigmasquadron ];
      mainProgram = "fish";
    };

    passthru = {
      shellPath = "/bin/fish";
      tests = {
        nixos = lib.optionalAttrs stdenv.hostPlatform.isLinux nixosTests.fish;

        # Test the fish_config tool by checking the generated splash page.
        # Since the webserver requires a port to run, it is not started.
        fishConfig =
          let fishScript = writeText "test.fish" ''
            set -x __fish_bin_dir ${fish}/bin
            echo $__fish_bin_dir
            cp -r ${fish}/share/fish/tools/web_config/* .
            chmod -R +w *

            # if we don't set `delete=False`, the file will get cleaned up
            # automatically (leading the test to fail because there's no
            # tempfile to check)
            ${lib.getExe gnused} -e 's@, mode="w"@, mode="w", delete=False@' -i webconfig.py

            # we delete everything after the fileurl is assigned
            ${lib.getExe gnused} -e '/fileurl =/q' -i webconfig.py
            echo "print(fileurl)" >> webconfig.py

            # and check whether the message appears on the page
            # cannot test the http server because it needs a localhost port
            cat (${python3}/bin/python ./webconfig.py \
              | tail -n1 | ${lib.getExe gnused} -e 's|file://||' \
            ) | ${lib.getExe gnugrep} -q 'a href="http://localhost.*Start the Fish Web config'
          '';
          in
          runCommand "test-web-config" { } ''
            HOME=$(mktemp -d)
            ${fish}/bin/fish ${fishScript} && touch $out
          '';
      };
      updateScript = nix-update-script { };
    };
  };
in
fish
