{ lib
, resholve
, fetchFromGitHub
, bash
, coreutils
, gnused
, gnugrep
, findutils
, ncurses
}:

resholve.mkDerivation rec {
  pname = "shunit2";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "kward";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IZHkgkVqzeh+eEKCDJ87sqNhSA+DU6kBCNDdQaUEeiM=";
  };

  installPhase = ''
    mkdir -p $out/bin/
    cp ./shunit2 $out/bin/shunit2
    chmod +x $out/bin/shunit2
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/shunit2
  '';

  solutions = {
    shunit = {
      # Caution: see __SHUNIT_CMD_ECHO_ESC before changing
      interpreter = "${bash}/bin/sh";
      scripts = [ "bin/shunit2" ];
      inputs = [ coreutils gnused gnugrep findutils ncurses ];
      # resholve's Nix API is analogous to the CLI flags
      # documented in 'man resholve'
      fake = {
        # "missing" functions shunit2 expects the user to declare
        function = [
          "oneTimeSetUp"
          "oneTimeTearDown"
          "setUp"
          "tearDown"
          "suite"
          "noexec"
        ];
        # shunit2 is both bash and zsh compatible, and in
        # some zsh-specific code it uses this non-bash builtin
        builtin = [ "setopt" ];
      };
      fix = {
        # stray absolute path; make it resolve from coreutils
        "/usr/bin/od" = true;
        /*
        Caution: this one is contextually debatable. shunit2
        sets this variable after testing whether `echo -e test`
        yields `test` or `-e test`. Since we're setting the
        interpreter, we can pre-test this. But if we go fiddle
        the interpreter later, I guess we _could_ break it.
        */
        "$__SHUNIT_CMD_ECHO_ESC" = [ "echo -e" ];
        "$SHUNIT_CMD_TPUT" = [ "tput" ]; # from ncurses
      };
      keep = {
        # dynamically defined in shunit2:_shunit_mktempFunc
        eval = [ "shunit_condition_" "_shunit_test_" "_shunit_prepForSourcing" ];

        # dynamic based on CLI flag
        "$_SHUNIT_LINENO_" = true;
      };
      execer = [
        # drop after https://github.com/abathur/binlore/issues/2
        "cannot:${ncurses}/bin/tput"
      ];
    };
  };

  meta = with lib; {
    homepage = "https://github.com/kward/shunit2";
    description = "XUnit based unit test framework for Bourne based shell scripts";
    maintainers = with maintainers; [ abathur utdemir ];
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "shunit2";
  };
}
