{ stdenv
, fetchFromGitHub
, libseccomp
, perl
, which
}:

stdenv.mkDerivation rec {
  name = "syscall_limiter-${version}";
  version = "${date}-${stdenv.lib.strings.substring 0 7 rev}";
  date = "20160105";
  rev = "b02c0316a2aaff496f712f1467e20337006655cc";

  src = fetchFromGitHub {
    owner = "vi";
    repo = "syscall_limiter";
    inherit rev;
    sha256 = "14q5k5c8hk7gnxhgwaamwbibasb3pwj6jnqsxa1bdp16n6jdajxd";
  };

  configurePhase = "";

  buildPhase = ''
    make CC="gcc -I${libseccomp}/include -L${libseccomp}/lib"
  '';

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
    homepage = https://github.com/vi/syscall_limiter;
    license = licenses.mit;
    maintainers = with maintainers; [ obadz ];
    platforms = platforms.linux;
  };
}
