{ lib, stdenv, fetchFromGitHub, bash, coreutils, gdb, zlib }:

stdenv.mkDerivation rec {
  pname = "procdump";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "ProcDump-for-Linux";
    rev = version;
    sha256 = "sha256-gVswAezHl7E2cBTJEQhPFXhHkzhWVHSpPF8m0s8+ekc=";
  };

  nativeBuildInputs = [ zlib ];
  buildInputs = [ bash coreutils gdb ];

  postPatch = ''
    substituteInPlace src/CoreDumpWriter.c \
      --replace '"gcore ' '"${gdb}/bin/gcore ' \
      --replace '"rm ' '"${coreutils}/bin/rm ' \
      --replace '/bin/bash' '${bash}/bin/bash'
  '';

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "INSTALLDIR=/bin"
    "MANDIR=/share/man/man1"
  ];

  doCheck = false; # needs sudo root

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    set +o pipefail
    ($out/bin/procdump -h | grep "ProcDump v${version}") ||
      (echo "ERROR: ProcDump is not the expected version or does not run properly" ; exit 1)
    set -o pipefail
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A Linux version of the ProcDump Sysinternals tool";
    homepage = "https://github.com/Microsoft/ProcDump-for-Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.linux;
  };
}
