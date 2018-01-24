{ stdenv, fetchurl, pkgconfig, libnl, popt, gnugrep }:

stdenv.mkDerivation rec {
  name = "ipvsadm-${version}";
  version = "1.29";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/ipvsadm/${name}.tar.xz";
    sha256 = "c3de4a21d90a02c621f0c72ee36a7aa27374b6f29fd4178f33fbf71b4c66c149";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "-lnl" "$(pkg-config --libs libnl-genl-3.0)"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl popt ];

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

  meta = with stdenv.lib; {
    description = "Linux Virtual Server support programs";
    homepage = http://www.linuxvirtualserver.org/software/ipvs.html;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
