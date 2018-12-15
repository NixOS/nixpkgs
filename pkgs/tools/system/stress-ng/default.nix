{ stdenv, fetchurl
, attr, keyutils, libaio, libapparmor, libbsd, libcap, libgcrypt, lksctp-tools, zlib
}:

stdenv.mkDerivation rec {
  name = "stress-ng-${version}";
  version = "0.09.46";

  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/${name}.tar.xz";
    sha256 = "0m1f46vqixx2mgqdrjwkl8w9did7n99sy96rbcgkkn9g99y59qjm";
  };

  # All platforms inputs then Linux-only ones
  buildInputs = [ libbsd libgcrypt zlib ]
    ++ stdenv.lib.optionals stdenv.hostPlatform.isLinux [
      attr keyutils libaio libapparmor libcap lksctp-tools
    ];

  patchPhase = ''
    substituteInPlace Makefile --replace "/usr" ""
  '';

  # Won't build on i686 because the binary will be linked again in the
  # install phase without checking the dependencies. This will prevent
  # triggering the rebuild. Why this only happens on i686 remains a
  # mystery, though. :-(
  enableParallelBuilding = (!stdenv.isi686);

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Stress test a computer system";
    longDescription = ''
      Stress test a system in various selectable ways, exercising both various
      physical subsystems and various operating system kernel interfaces:
      - over 130 different stress tests
      - over 70 CPU specific stress tests that exercise floating point,
        integer, bit manipulation and control flow
      - over 20 virtual memory stress tests
      stress-ng was originally intended to make a machine work hard and trip
      hardware issues such as thermal overruns as well as operating system
      bugs that only occur when a system is being thrashed hard.
    '';
    homepage = http://kernel.ubuntu.com/~cking/stress-ng/;
    downloadPage = http://kernel.ubuntu.com/~cking/tarballs/stress-ng/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.linux; # TODO: fix https://github.com/NixOS/nixpkgs/pull/50506#issuecomment-439635963
  };
}
