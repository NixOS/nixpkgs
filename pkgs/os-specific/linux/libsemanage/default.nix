{ stdenv, fetchurl, libsepol, libselinux, ustr, bzip2, bison, flex }:
stdenv.mkDerivation rec {

  name = "libsemanage-${version}";
  version = "2.0.46";

  src = fetchurl {
    url = "http://userspace.selinuxproject.org/releases/20101221/devel/${name}.tar.gz";
    sha256 = "03ljdw48pn8vlk4h26w8z247c9wykp2198s1ksmxrai3avyz87wf";
  };

  NIX_LDFLAGS = "-lsepol";

  makeFlags = "PREFIX=$(out) DESTDIR=$(out)";

  buildInputs = [ libsepol libselinux ustr bzip2 bison flex ];

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org/;
    description = "Policy management tools for SELinux";
    license = licenses.lgpl21;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}