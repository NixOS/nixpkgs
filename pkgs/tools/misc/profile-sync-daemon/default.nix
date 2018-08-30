{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "5.53";
  name = "profile-sync-daemon-${version}";

  src = fetchurl {
    url = "http://github.com/graysky2/profile-sync-daemon/archive/v${version}.tar.gz";
    sha256 = "0m7h9l7dndqgb5k3grpc00f6dpg73p6h4q5sgkf8bvyzvcbdafwx";
  };

  installPhase = "PREFIX=\"\" DESTDIR=$out make install-systemd-all";

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "Syncs browser profile dirs to RAM";
    longDescription = ''
      Profile-sync-daemon (psd) is a tiny pseudo-daemon designed to manage your
      browser's profile in tmpfs and to periodically sync it back to your
      physical disc (HDD/SSD). This is accomplished via a symlinking step and
      an innovative use of rsync to maintain back-up and synchronization
      between the two. One of the major design goals of psd is a completely
      transparent user experience.
    '';
    homepage = https://github.com/graysky2/profile-sync-daemon;
    downloadPage = https://github.com/graysky2/profile-sync-daemon/releases;
    license = licenses.mit;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.linux;
  };
}
