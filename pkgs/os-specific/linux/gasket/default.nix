{ lib, stdenv, fetchurl, dpkg, kernel }:

stdenv.mkDerivation rec {
  pname = "gasket";
  version = "1.0";
  revision = "18";
  name = "gasket-${version}";

  src = fetchurl {
    url = "https://packages.cloud.google.com/apt/pool/gasket-dkms_1.0-18_all_00606bc20aed9a7d2a9da7a6d51a87dbc7f275be392fb3e1131ef6f627a49168.deb";
    name = "gasket-dkms_${version}-${revision}.deb";
    sha256 = "0s4ilhkzdxhy2ghv6brrprsz5iyvhwddb9m7klm7v6pd1b16nq00";
  };

  hardeningDisable = [ "pic" ];

  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x "$src" .
    cd usr/src/gasket-1.0
  '';

  patchPhase = ''
    sed -i "s|/lib/modules/\$(KVERSION)/build|${KSRC}|g" Makefile
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/staging/gasket
    install -Dm644 apex.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/staging/gasket
    install -Dm644 gasket.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/staging/gasket
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Gasket provides support for Google ASICs, e.g: the Coral EdgeTPU.";
    homepage = "https://coral.withgoogle.com/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.luker ];
    platforms = platforms.linux;
  };
}

