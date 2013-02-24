{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsepol-${version}";
  version = "2.1.8";
  se_release = "20120924";
  se_url = "${meta.homepage}/releases";

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "1w38q3lmha5m9aps9w844i51yw4b8q1vhpng2kdywn2n8cpdvvk3";
  };

  preBuild = '' makeFlags="$makeFlags PREFIX=$out DESTDIR=$out" '';

  passthru = { inherit se_release se_url meta; };

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    license = "GPLv2";
  };
}
