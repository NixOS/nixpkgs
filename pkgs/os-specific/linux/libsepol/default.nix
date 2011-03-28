{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libsepol-${version}";
  version = "2.0.42";

  src = fetchurl {
    url = "http://userspace.selinuxproject.org/releases/20101221/devel/${name}.tar.gz";
    sha256 = "0sg61mb9qhyh4vplasar6nwd6j123v453zss93qws3h95fhrfc08";
  };

  preBuild = '' makeFlags="$makeFlags PREFIX=$out DESTDIR=$out" '';
}
