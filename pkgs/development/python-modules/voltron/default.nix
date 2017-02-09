{
stdenv, pkgs, python, wrapPython, buildPythonPackage, isPy3k,
nose, mock, pexpect,
requests-unixsocket, pysigset, blessed, Flask-RESTful, scruffington, pygments, requests, requests2
}:

buildPythonPackage rec {
    name = "voltron-${version}";
    version = "0.1.7";
    src = pkgs.fetchurl {
        # github release not PyPI so we have tests
        url = "https://github.com/snare/voltron/archive/v${version}.tar.gz";
        sha256 = "0qvznkrr2m90x96ac246kwxqrkpvwda0fh6zrqnnf1dwbszdl699";
    };
    # fails in tests.gdb_cli_tests.test_disassemble
    # and because of wrong lldb version, mitigated in sed below
    doCheck = false;
    # $HOME is by default not a valid dir, so we have to set that too
    # https://github.com/NixOS/nixpkgs/issues/12591
    # taken from the voltron .travis.yml
    checkPhase = ''
      export HOME=$TMPDIR
      mkdir ~/.voltron/
      echo '{"general":{"debug_logging":true}}' >~/.voltron/config
      sed -i "s|p = pexpect.spawn('lldb-3.4')|p = pexpect.spawn('lldb')|" tests/lldb_cli_tests.py
      nosetests
    '';
    meta = with stdenv.lib; {
        description = "A hacky debugger UI for hackers";
        homepage    = "https://github.com/snare/voltron";
        license     = licenses.mit;
        platforms   = platforms.all;
    };
    buildInputs = [ nose mock pexpect ];
    propagatedBuildInputs = [ requests-unixsocket pysigset blessed Flask-RESTful scruffington pygments pkgs.llvmPackages.lldb pkgs.gdb ]
        ++ (if isPy3k then [requests2] else [requests]);
    maintainer = with stdenv.lib.maintainers; [ psychomario ];
}
