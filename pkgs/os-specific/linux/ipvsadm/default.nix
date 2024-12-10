{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libnl,
  popt,
  gnugrep,
}:

stdenv.mkDerivation rec {
  pname = "ipvsadm";
  version = "1.31";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/ipvsadm/${pname}-${version}.tar.xz";
    sha256 = "1nyzpv1hx75k9lh0vfxfhc0p2fpqaqb38xpvs8sn88m1nljmw2hs";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "-lnl" "$(pkg-config --libs libnl-genl-3.0)"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libnl
    popt
  ];

  # Disable parallel build, errors:
  #  *** No rule to make target 'libipvs/libipvs.a', needed by 'ipvsadm'.  Stop.
  enableParallelBuilding = false;

  preBuild = ''
    makeFlagsArray+=(
      INCLUDE=$(pkg-config --cflags libnl-genl-3.0)
      BUILD_ROOT=$out
      MANDIR=share/man
    )
  '';

  postInstall = ''
    sed -i -e "s|^PATH=.*|PATH=$out/bin:${gnugrep}/bin|" $out/sbin/ipvsadm-{restore,save}
  '';

  meta = with lib; {
    description = "Linux Virtual Server support programs";
    homepage = "http://www.linuxvirtualserver.org/software/ipvs.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
