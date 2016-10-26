{ stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  name = "libsepol-${version}";
  version = "2.4";
  se_release = "20150202";
  se_url = "https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases";

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "0ncnwhpc1gx4hrrb822fqkwy5h75zzngsrfkd5mlqh1jk7aib419";
  };

  nativeBuildInputs = [ flex ];

  # Temporary work-around for problems after flex security update:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=835542
  NIX_CFLAGS_COMPILE = "-Wno-error=sign-compare";

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
  '';

  passthru = { inherit se_release se_url; };

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    license = stdenv.lib.licenses.gpl2;
  };
}
