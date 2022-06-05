{ lib, stdenv, mkDerivation, fetchFromGitHub
, cmake, pkg-config, pffft, libpcap, libusb1, python3
}:

mkDerivation rec {
  pname = "hobbits";
  version = "0.53.1";

  src = fetchFromGitHub {
    owner = "Mahlet-Inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dMFsv2M96+65JxTOq0CG+vm7a75GkD7N7PmbsyZ2Fog=";
  };

  postPatch = ''
    substituteInPlace src/hobbits-core/settingsdata.cpp \
      --replace "pythonHome = \"/usr\"" "pythonHome = \"${python3}\""
    substituteInPlace cmake/gitversion.cmake \
      --replace "[Mystery Build]" "${version}"
  '';

  buildInputs = [ pffft libpcap libusb1 python3 ];

  nativeBuildInputs = [ cmake pkg-config ];

  NIX_CFLAGS_COMPILE = lib.optional stdenv.hostPlatform.isAarch64 "-Wno-error=narrowing";

  meta = with lib; {
    description = "A multi-platform GUI for bit-based analysis, processing, and visualization";
    homepage = "https://github.com/Mahlet-Inc/hobbits";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
