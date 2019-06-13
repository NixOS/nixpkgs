{ stdenv
, fetchFromGitHub
, libseccomp
, perl
, which
}:

stdenv.mkDerivation rec {
  name    = "syscall_limiter-${version}";
  version = "2017-01-23";

  src = fetchFromGitHub {
    owner  = "vi";
    repo   = "syscall_limiter";
    rev    = "481c8c883f2e1260ebc83b352b63bf61a930a341";
    sha256 = "0z5arj1kq1xczgrbw1b8m9kicbv3vs9bd32wvgfr4r6ndingsp5m";
  };

  buildInputs = [ libseccomp ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v limit_syscalls $out/bin
    cp -v monitor.sh $out/bin/limit_syscalls_monitor.sh
    substituteInPlace $out/bin/limit_syscalls_monitor.sh \
      --replace perl ${perl}/bin/perl \
      --replace which ${which}/bin/which
  '';

  meta = with stdenv.lib; {
    description = "Start Linux programs with only selected syscalls enabled";
    homepage    = https://github.com/vi/syscall_limiter;
    license     = licenses.mit;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.linux;
  };
}
