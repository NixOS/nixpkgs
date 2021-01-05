{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, libusb1
, libedit
, curl
, gengetopt
, pkg-config
, pcsclite
, help2man
}:

stdenv.mkDerivation rec {
  pname = "yubihsm-shell";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-shell";
    rev = version;
    sha256 = "D0kXiwc+i6mKA4oHuHjgXUmLMsmY5o/VI+1aCWtNjC0=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    help2man
    gengetopt
  ];

  buildInputs = [
    libusb1
    libedit
    curl
    pcsclite
    openssl
  ];

  postPatch = ''
    # Can't find libyubihsm at runtime because of dlopen() in C code
    substituteInPlace lib/yubihsm.c \
      --replace "libyubihsm_usb.so" "$out/lib/libyubihsm_usb.so" \
      --replace "libyubihsm_http.so" "$out/lib/libyubihsm_http.so"
  '';

  meta = with lib; {
    description = "yubihsm-shell and libyubihsm";
    homepage = "https://github.com/Yubico/yubihsm-shell";
    maintainers = with maintainers; [ matthewcroughan ];
    license = licenses.asl20;
  };
}
