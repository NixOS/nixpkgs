{ lib
, stdenv
, fetchFromGitHub
, kernel
, klibc
}:

stdenv.mkDerivation rec {
  name = "v86d-${version}-${kernel.version}";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "mjanusz";
    repo = "v86d";
    rev = "v86d-${version}";
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
    description = "A daemon to run x86 code in an emulated environment";
    homepage = "https://github.com/mjanusz/v86d";
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
