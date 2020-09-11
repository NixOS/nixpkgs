{ stdenv, fetchFromGitHub, cmake, ocl-icd, opencl-clhpp }:

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

  nativeBuildInputs = [ cmake ];

  buildInputs = [ ocl-icd opencl-clhpp ];

  meta = with stdenv.lib; {
    description = "A tool which profiles OpenCL devices to find their peak capacities";
    homepage = "https://github.com/krrishnarraj/clpeak/";
    license = licenses.unlicense;
    maintainers = with maintainers; [ danieldk ];
  };
}
