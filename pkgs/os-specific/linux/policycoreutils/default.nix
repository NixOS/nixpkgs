{ stdenv, fetchurl, libsepol, libselinux }:
stdenv.mkDerivation rec {

  name = "policycoreutils-${version}";
  version = "2.0.85";

  src = fetchurl {
    url = http://userspace.selinuxproject.org/releases/20101221/devel/policycoreutils-2.0.85.tar.gz;
    sha256 = "01q5ifacg24k9jdz85j9m17ps2l1p7abvh8pzy6qz55y68rycifb";
  };

  buildInputs = [ libsepol libselinux ];

  NIX_LDFLAGS = "-lsepol";

  makeFlags = "LOCALEDIR=$(out)/share/locale";

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org/;
    description = "SELinux policy core utilities";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}