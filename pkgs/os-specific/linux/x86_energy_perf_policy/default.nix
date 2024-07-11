{ lib, stdenv, kernel }:

stdenv.mkDerivation {
  pname = "x86_energy_perf_policy";
  version = kernel.version;

  src = kernel.src;

  postPatch = ''
    cd tools/power/x86/x86_energy_perf_policy
    sed -i 's,/usr,,g' Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man8
  '';

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Set the energy versus performance policy preference bias on recent X86 processors";
    mainProgram = "x86_energy_perf_policy";
    homepage = "https://www.kernel.org/";
    license = licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ]; # x86-specific
  };
}
