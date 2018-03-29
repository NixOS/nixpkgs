{ stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  name = "libsepol-${version}";
  version = "2.7";
  se_release = "20170804";
  se_url = "https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases";

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "1rzr90d3f1g5wy1b8sh6fgnqb9migys2zgpjmpakn6lhxkc3p7fn";
  };

  nativeBuildInputs = [ flex ];

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
    makeFlagsArray+=("MAN8DIR=$out/share/man/man8")
    makeFlagsArray+=("MAN3DIR=$out/share/man/man3")
  '';

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  passthru = { inherit se_release se_url; };

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    license = stdenv.lib.licenses.gpl2;
  };
}
