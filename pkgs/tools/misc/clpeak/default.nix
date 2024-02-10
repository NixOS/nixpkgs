{ lib, stdenv, fetchFromGitHub, cmake, ocl-icd, opencl-clhpp }:

stdenv.mkDerivation rec {
  pname = "clpeak";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "krrishnarraj";
    repo = "clpeak";
    rev = version;
    fetchSubmodules = true;
    sha256 = "1wkjpvn4r89c3y06rv7gfpwpqw6ljmqwz0w0mljl9y5hn1r4pkx2";
  };

  patches = [
    # The cl.hpp header was removed from opencl-clhpp. This patch
    # updates clpeak to use the new cp2.hpp header. The patch comes
    # from the following PR and was updated to apply against more
    # recent versions: https://github.com/krrishnarraj/clpeak/pull/46
    ./clpeak-clhpp2.diff
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ ocl-icd opencl-clhpp ];

  meta = with lib; {
    description = "A tool which profiles OpenCL devices to find their peak capacities";
    homepage = "https://github.com/krrishnarraj/clpeak/";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
    mainProgram = "clpeak";
  };
}
