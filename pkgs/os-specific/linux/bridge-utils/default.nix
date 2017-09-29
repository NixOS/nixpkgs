{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "bridge-utils-1.5";

  src = fetchurl {
    url = "mirror://sourceforge/bridge/${name}.tar.gz";
    sha256 = "42f9e5fb8f6c52e63a98a43b81bd281c227c529f194913e1c51ec48a393b6688";
  };

  # Remove patch once the kernel headers are updated
  patches = [ ./add-ip6-header.patch ];

  buildInputs = [ autoreconfHook ];

  postInstall = ''
    # The bridge utils build does not fail even if the brctl binary
    # is not build. This test ensures that we fail if we don't produce a brctl
    # binary.
    test -f $out/sbin/brctl
  '';

  meta = {
    description = "http://sourceforge.net/projects/bridge/";
    homepage = http://www.linux-foundation.org/en/Net:Bridge/;
    license = "GPL";
    platforms = stdenv.lib.platforms.linux;
  };
}
