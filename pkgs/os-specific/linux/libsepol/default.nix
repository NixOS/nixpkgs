{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsepol-${version}";
  version = "2.3";
  se_release = "20140506";
  se_url = "${meta.homepage}/releases";

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "13z6xakc2qqyhlvnc5h53jy7lqmh5b5cnpfn51lmvfdpqd18d3fc";
  };

  preBuild = '' makeFlags="$makeFlags PREFIX=$out DESTDIR=$out" '';

  # TODO: Figure out why the build incorrectly links libsepol.so
  postInstall = ''
    rm $out/lib/libsepol.so
    ln -s libsepol.so.1 $out/lib/libsepol.so
  '';

  passthru = { inherit se_release se_url; };

  meta = with stdenv.lib; {
    homepage = http://userspace.selinuxproject.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    license = stdenv.lib.licenses.gpl2;
  };
}
