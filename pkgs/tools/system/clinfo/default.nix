{ stdenv, fetchFromGitHub, ocl-icd, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "clinfo";
  version = "2.2.18.04.06";

    src = fetchFromGitHub {
      owner = "Oblomov";
      repo = "clinfo";
      rev = version;
      sha256 = "0y2q0lz5yzxy970b7w7340vp4fl25vndahsyvvrywcrn51ipgplx";
    };

  buildInputs = [ ocl-icd opencl-headers ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=stringop-truncation" ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Print all known information about all available OpenCL platforms and devices in the system";
    homepage = https://github.com/Oblomov/clinfo;
    license = licenses.cc0;
    platforms = platforms.linux;
    maintainers = with maintainers; [ athas ];
  };
}
