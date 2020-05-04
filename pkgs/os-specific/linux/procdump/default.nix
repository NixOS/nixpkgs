{ stdenv, fetchFromGitHub, bash, coreutils, gdb, zlib }:

stdenv.mkDerivation rec {
  pname = "procdump";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "ProcDump-for-Linux";
    rev = version;
    sha256 = "0h5fhk39d10kjbinzw1yp6nr8w8l300mn9qxrkpivdkyfn6bpq2f";
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

  meta = with stdenv.lib; {
    description = "A Linux version of the ProcDump Sysinternals tool";
    homepage = "https://github.com/Microsoft/ProcDump-for-Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.linux;
  };
}
