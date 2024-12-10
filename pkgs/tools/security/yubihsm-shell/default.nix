{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  libusb1,
  libedit,
  curl,
  gengetopt,
  pkg-config,
  pcsclite,
  help2man,
  darwin,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "yubihsm-shell";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-shell";
    rev = version;
    hash = "sha256-QTDFL/UTnnG0TuojJ0eVKw8fNEqZz86CXWb6uHvzUbs=";
  };

  postPatch = ''
    # Can't find libyubihsm at runtime because of dlopen() in C code
    substituteInPlace lib/yubihsm.c \
      --replace "libyubihsm_usb.so" "$out/lib/libyubihsm_usb.so" \
      --replace "libyubihsm_http.so" "$out/lib/libyubihsm_http.so"
    # ld: unknown option: -z
    substituteInPlace CMakeLists.txt cmake/SecurityFlags.cmake \
      --replace "AppleClang" "Clang"
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    help2man
    gengetopt
  ];

  buildInputs =
    [
      libusb1
      libedit
      curl
      openssl
    ]
    ++ lib.optionals stdenv.isLinux [
      pcsclite
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.PCSC
      libiconv
    ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
    "-DDISABLE_LTO=ON"
  ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = "yubihsm-shell and libyubihsm";
    homepage = "https://github.com/Yubico/yubihsm-shell";
    maintainers = with maintainers; [ matthewcroughan ];
    license = licenses.asl20;
  };
}
