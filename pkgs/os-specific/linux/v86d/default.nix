{ stdenv, fetchurl
, kernel, klibc
}:

stdenv.mkDerivation rec {
  name = "v86d-${version}-${kernel.version}";
  version = "0.1.10";

  src = fetchurl {
    url = "https://github.com/mjanusz/v86d/archive/v86d-${version}.tar.gz";
    sha256 = "1flnpp8rc945cxr6jr9dlm8mi8gr181zrp2say4269602s1a4ymg";
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

  meta = with stdenv.lib; {
    description = "A daemon to run x86 code in an emulated environment";
    homepage = https://github.com/mjanusz/v86d;
    license = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
