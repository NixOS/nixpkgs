{ lib, stdenv, fetchFromGitHub, util-linux, coreutils }:

stdenv.mkDerivation rec {
  name = "profile-sync-daemon-user";

  src = fetchFromGitHub {
    owner = "Xervon";
    repo = "profile-sync-daemon";
    rev = "4d067f2";
    sha256 = "1nslw3qqg1m6cpfv08ijpz1hnlmsd8i75pqws6lr1hpjqllz3ad4";
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
    homepage = "https://github.com/Xervon/profile-sync-daemon";
    downloadPage = "https://github.com/Xervon/profile-sync-daemon/releases";
    license = licenses.mit;
    maintainers = [ maintainers.grburst ];
    platforms = platforms.linux;
  };
}
