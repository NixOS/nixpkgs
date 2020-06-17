{ stdenv, fetchFromGitHub, makeWrapper, file, findutils
, binutils-unwrapped, glibc, coreutils, sysctl, openssl
}:

stdenv.mkDerivation rec {
  pname = "checksec";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "slimm609";
    repo = "checksec.sh";
    rev = version;
    sha256 = "035ydf7kp9yh5gpjnq4cgi76j582a0q6dxcbgkraxpkml0d8n2xd";
  };

  patches = [ ./0001-attempt-to-modprobe-config-before-checking-kernel.patch ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = let
    path = stdenv.lib.makeBinPath [
      findutils file binutils-unwrapped sysctl openssl
    ];
  in ''
    mkdir -p $out/bin
    install checksec $out/bin
    substituteInPlace $out/bin/checksec --replace /lib/libc.so.6 ${glibc.out}/lib/libc.so.6
    substituteInPlace $out/bin/checksec --replace "/usr/bin/id -" "${coreutils}/bin/id -"
    wrapProgram $out/bin/checksec \
      --prefix PATH : ${path}
  '';

  meta = with stdenv.lib; {
    description = "A tool for checking security bits on executables";
    homepage    = "http://www.trapkit.de/tools/checksec.html";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice globin ];
  };
}
