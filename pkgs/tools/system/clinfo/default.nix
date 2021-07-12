{ lib, stdenv, fetchFromGitHub, ocl-icd, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "clinfo";
  version = "3.0.21.02.21";

  src = fetchFromGitHub {
    owner = "Oblomov";
    repo = "clinfo";
    rev = version;
    sha256 = "sha256-0ijfbfv1F6mnt1uFH/A4yOADJoAFrPMa3yAOFJW53ek=";
  };

  buildInputs = [ ocl-icd opencl-headers ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=stringop-overflow"
    "-Wno-error=stringop-truncation"
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Print all known information about all available OpenCL platforms and devices in the system";
    homepage = "https://github.com/Oblomov/clinfo";
    license = licenses.cc0;
    maintainers = with maintainers; [ athas ];
    platforms = platforms.linux;
  };
}
