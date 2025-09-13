{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  klibc,
}:

let
  pversion = "0.1.10";
in
stdenv.mkDerivation {
  pname = "v86d";
  version = "${pversion}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "mjanusz";
    repo = "v86d";
    tag = "v86d-${pversion}";
    hash = "sha256-95LRzVbO/DyddmPwQNNQ290tasCGoQk7FDHlst6LkbA=";
  };

  postPatch = ''
    patchShebangs configure
  '';

  # GCC 14 makes this an error by default, remove when fixed upstream
  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -Wno-implicit-int";

  configureFlags = [
    "--with-klibc"
    "--with-x86emu"
  ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "DESTDIR=$(out)"
  ];

  configurePhase = ''
    runHook preConfigure

    ./configure $configureFlags

    runHook postConfigure
  '';

  buildInputs = [ klibc ];

  meta = {
    description = "Daemon to run x86 code in an emulated environment";
    mainProgram = "v86d";
    homepage = "https://github.com/mjanusz/v86d";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ codyopel ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
