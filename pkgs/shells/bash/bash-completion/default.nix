{ stdenv, fetchFromGitHub
, fetchpatch
, autoreconfHook
, perl
, ps
, python3Packages
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "bash-completion";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "scop";
    repo = "bash-completion";
    rev = version;
    sha256 = "047yjryy9d6hp18wkigbfrw9r0sm31inlsp8l28fhxg8ii032sgq";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = !stdenv.isDarwin;
  checkInputs = [
    # perl is assumed by perldoc completion
    perl
    # ps assumed to exist by gdb, killall, pgrep, pidof,
    # pkill, pwdx, renice, and reptyr completions
    ps
    python3Packages.pexpect
    python3Packages.pytest
    bashInteractive
  ];

  # - ignore test_gcc on ARM because it assumes -march=native
  # - ignore test_chsh because it assumes /etc/shells exists
  # - ignore test_ether_wake, test_ifdown, test_ifstat, test_ifup,
  #   test_iperf, test_iperf3, test_nethogs and ip_addresses
  #   because they try to touch network
  # - ignore test_ls because impure logic
  # - ignore test_screen because it assumes vt terminals exist
  checkPhase = ''
    pytest . \
      ${stdenv.lib.optionalString (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isAarch32) "--ignore=test/t/test_gcc.py"} \
      --ignore=test/t/test_chsh.py \
      --ignore=test/t/test_ether_wake.py \
      --ignore=test/t/test_ifdown.py \
      --ignore=test/t/test_ifstat.py \
      --ignore=test/t/test_ifup.py \
      --ignore=test/t/test_iperf.py \
      --ignore=test/t/test_iperf3.py \
      --ignore=test/t/test_nethogs.py \
      --ignore=test/t/unit/test_unit_ip_addresses.py \
      --ignore=test/t/test_ls.py \
      --ignore=test/t/test_screen.py
  '';

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e 's/readlink -f/readlink/g' bash_completion completions/*
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/scop/bash-completion";
    description = "Programmable completion for the bash shell";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.peti maintainers.xfix ];
  };
}
