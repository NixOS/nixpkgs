{ lib, stdenv, fetchurl, util-linux, coreutils}:

stdenv.mkDerivation rec {
  version = "6.44";
  pname = "profile-sync-daemon";

  src = fetchurl {
    url = "https://github.com/graysky2/profile-sync-daemon/archive/v${version}.tar.gz";
    sha256 = "sha256-+iQr7T99X/jYYgq0xNHLPCJG5mZU/6dN76Z1FB51Z54=";
  };

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    substituteInPlace $out/bin/profile-sync-daemon \
      --replace "/usr/" "$out/" \
      --replace "sudo " "/run/wrappers/bin/sudo "
    # $HOME detection fails (and is unnecessary)
    sed -i '/^HOME/d' $out/bin/profile-sync-daemon
    substituteInPlace $out/bin/psd-overlay-helper \
      --replace "PATH=/usr/bin:/bin" "PATH=${util-linux.bin}/bin:${coreutils}/bin" \
      --replace "sudo " "/run/wrappers/bin/sudo "
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Syncs browser profile dirs to RAM";
    longDescription = ''
      Profile-sync-daemon (psd) is a tiny pseudo-daemon designed to manage your
      browser's profile in tmpfs and to periodically sync it back to your
      physical disc (HDD/SSD). This is accomplished via a symlinking step and
      an innovative use of rsync to maintain back-up and synchronization
      between the two. One of the major design goals of psd is a completely
      transparent user experience.
    '';
    homepage = "https://github.com/graysky2/profile-sync-daemon";
    downloadPage = "https://github.com/graysky2/profile-sync-daemon/releases";
    license = licenses.mit;
    maintainers = [ maintainers.prikhi ];
    platforms = platforms.linux;
  };
}
