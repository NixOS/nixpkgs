{stdenv, fetchurl, libsepol}:

stdenv.mkDerivation rec {
  name = "libselinux-${version}";
  version = "2.0.98";

  src = fetchurl {
    url = "http://userspace.selinuxproject.org/releases/20101221/devel/${name}.tar.gz";
    sha256 = "00irm7nyakgi4z8d6dlm6c70fkbl6rzk5w1w0ny2c564yw0d0dlz";
  };

  buildInputs = [ libsepol ];

  preBuild = '' makeFlags="$makeFlags PREFIX=$out DESTDIR=$out" '';
}
