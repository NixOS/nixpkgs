{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "iotools";
  version = "unstable-2017-12-11";

  src = fetchFromGitHub {
    owner = "adurbin";
    repo = pname;
    rev = "18949fdc4dedb1da3f51ee83a582b112fb9f2c71";
    sha256 = "0vymnah44d5bzsjhfmxkcrlrikkp0db22k7a1s8bknz7glk9fldn";
  };

  makeFlags = [ "DEBUG=0" "STATIC=0" ];

  installPhase = ''
    install -Dm755 iotools -t $out/bin
  '';

  meta = with lib; {
    description = "Set of simple command line tools which allow access to
      hardware device registers";
    longDescription = ''
      Provides a set of simple command line tools which allow access to
      hardware device registers. Supported register interfaces include PCI,
      IO, memory mapped IO, SMBus, CPUID, and MSR. Also included are some
      utilities which allow for simple arithmetic, logical, and other
      operations.
    '';
    homepage = "https://github.com/adurbin/iotools";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ felixsinger ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    mainProgram = "iotools";
  };
}
