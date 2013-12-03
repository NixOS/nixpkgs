{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsepol-${version}";
  version = "2.2";
  se_release = "20131030";
  se_url = "${meta.homepage}/releases";

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "03zw6clp00cmi49x8iq8svhrp91jrcw0093zpnyhan190rqb593p";
  };

  preBuild = '' makeFlags="$makeFlags PREFIX=$out DESTDIR=$out" '';

  # TODO: Figure out why the build incorrectly links libsepol.so
  postInstall = ''
    rm $out/lib/libsepol.so
    ln -s libsepol.so.1 $out/lib/libsepol.so
  '';

  passthru = { inherit se_release se_url meta; };

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    license = "GPLv2";
  };
}
