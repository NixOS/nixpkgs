{ lib, stdenv, fetchFromGitHub, fetchpatch, bash, coreutils, gdb, zlib }:

stdenv.mkDerivation rec {
  pname = "procdump";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "ProcDump-for-Linux";
    rev = version;
    sha256 = "sha256-gVswAezHl7E2cBTJEQhPFXhHkzhWVHSpPF8m0s8+ekc=";
  };

  patches = [
    # Pull upstream patch to fix parallel builds:
    #  https://github.com/Sysinternals/ProcDump-for-Linux/pull/133
    (fetchpatch {
      name = "parallel.patch";
      url = "https://github.com/Sysinternals/ProcDump-for-Linux/commit/0d735836f11281cc6134be93eac8acb302f2055e.patch";
      sha256 = "sha256-zsqllPHF8ZuXAIDSAPvbzdKa43uSSx9ilUKM1vFVW90=";
    })
  ];

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

  enableParallelBuilding = true;

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
    mainProgram = "procdump";
    homepage = "https://github.com/Microsoft/ProcDump-for-Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.linux;
  };
}
