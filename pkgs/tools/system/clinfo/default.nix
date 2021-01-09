{ stdenv, fetchFromGitHub, ocl-icd, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "clinfo";
  version = "3.0.20.11.20";

  src = fetchFromGitHub {
    owner = "Oblomov";
    repo = "clinfo";
    rev = version;
    sha256 = "052xfkbmgfpalmhfwn0dj5114x2mzwz29y37qqhhsdpaxsz0y422";
  };

  buildInputs = [ ocl-icd opencl-headers ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=stringop-overflow"
    "-Wno-error=stringop-truncation"
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Print all known information about all available OpenCL platforms and devices in the system";
    homepage = "https://github.com/Oblomov/clinfo";
    license = licenses.cc0;
    maintainers = with maintainers; [ athas ];
    platforms = platforms.linux;
  };
}
