{ lib, stdenv, kernel }:

stdenv.mkDerivation {
  pname = "intel-speed-select";
  inherit (kernel) src version;

  makeFlags = [ "bindir=${placeholder "out"}/bin" ];

  postPatch = ''
    cd tools/power/x86/intel-speed-select
    sed -i 's,/usr,,g' Makefile
  '';

  meta = with lib; {
    description = "Tool to enumerate and control the Intel Speed Select Technology features";
    mainProgram = "intel-speed-select";
    homepage = "https://www.kernel.org/";
    license = licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" ]; # x86-specific
    broken = kernel.kernelAtLeast "5.18";
  };
}
