{ lib
, stdenv
, fetchFromGitHub
, kernel
, klibc
}:

let
  pversion = "0.1.10";
in stdenv.mkDerivation rec {
  pname = "v86d";
  version = "${pversion}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "mjanusz";
    repo = "v86d";
    rev = "v86d-${pversion}";
    hash = "sha256-95LRzVbO/DyddmPwQNNQ290tasCGoQk7FDHlst6LkbA=";
  };

  patchPhase = ''
    patchShebangs configure
  '';

  configureFlags = [ "--with-klibc" "--with-x86emu" ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
    "DESTDIR=$(out)"
  ];

  configurePhase = ''
    ./configure $configureFlags
  '';

  buildInputs = [ klibc ];

  meta = with lib; {
    description = "Daemon to run x86 code in an emulated environment";
    mainProgram = "v86d";
    homepage = "https://github.com/mjanusz/v86d";
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
