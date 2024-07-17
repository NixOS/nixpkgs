{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  bc,
  nukeReferences,
}:

stdenv.mkDerivation rec {
  name = "rtl8189es-${kernel.version}-${version}";
  version = "2024-01-21";

  src = fetchFromGitHub {
    owner = "jwrdegoede";
    repo = "rtl8189ES_linux";
    rev = "eb51e021b0e1b6f94a4b49da3f4ee5c5fb20b715";
    sha256 = "sha256-n7Bsstr1H1RvguAyJnVqk/JgEx8WEZWaVg7ZfEYykR0=";
  };

  nativeBuildInputs = [
    bc
    nukeReferences
  ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [
    "pic"
    "format"
  ];

  prePatch = ''
    substituteInPlace ./Makefile --replace /lib/modules/ "${kernel.dev}/lib/modules/"
    substituteInPlace ./Makefile --replace /sbin/depmod \#
    substituteInPlace ./Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  makeFlags = kernel.makeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    (
      "CONFIG_PLATFORM_I386_PC="
      + (if (stdenv.hostPlatform.isi686 || stdenv.hostPlatform.isx86_64) then "y" else "n")
    )
    ("CONFIG_PLATFORM_ARM_RPI=" + (if stdenv.hostPlatform.isAarch then "y" else "n"))
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  meta = with lib; {
    description = "Driver for Realtek rtl8189es";
    homepage = "https://github.com/jwrdegoede/rtl8189ES_linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      danielfullmer
      lheckemann
    ];
  };
}
