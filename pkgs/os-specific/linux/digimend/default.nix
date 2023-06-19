{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "digimend";
  version = "unstable-2023-05-03";

  src = fetchFromGitHub {
    owner = "digimend";
    repo = "digimend-kernel-drivers";
    rev = "eca6e1b701bffb80a293234a485ebf6b4bc85562";
    hash = "sha256-0mjIUgHvbNcVQVzU3xzaloe5R41a4eknDhdhruJH+6c=";
  };

  postPatch = ''
    sed 's/udevadm /true /' -i Makefile
    sed 's/depmod /true /' -i Makefile
  '';

  # Fix build on Linux kernel >= 5.18
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=implicit-fallthrough" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  postInstall = ''
    # Remove module reload hack.
    # The hid-rebind unloads and then reloads the hid-* module to ensure that
    # the extra/ module is loaded.
    rm -r $out/lib/udev
  '';

  makeFlags = kernel.makeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=${placeholder "out"}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "DIGImend graphics tablet drivers for the Linux kernel";
    homepage = "https://digimend.github.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.linux;
  };
}
