{ cmake, fetchFromGitHub, opencv3, stdenv, opencl-headers
, cudaSupport ? false, cudatoolkit ? null
}:

stdenv.mkDerivation rec {
  pname = "waifu2x-converter-cpp";
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "DeadSix27";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r7xcjqbyaa20gsgmjj7645640g3nb2bn1pc1nlfplwlzjxmz213";
  };

  patchPhase = ''
    # https://github.com/DeadSix27/waifu2x-converter-cpp/issues/123
    sed -i 's:{"PNG",  false},:{"PNG",  true},:' src/main.cpp
  '';

  buildInputs = [
    opencv3 opencl-headers
  ] ++ stdenv.lib.optional cudaSupport cudatoolkit;

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Improved fork of Waifu2X C++ using OpenCL and OpenCV";
    homepage = https://github.com/DeadSix27/waifu2x-converter-cpp;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.xzfc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
