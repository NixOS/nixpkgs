{ stdenv, fetchFromGitHub, makeWrapper, clamav, rsync, coreutils, gnutar, gnugrep, curl, gzip, dnsutils, gnupg, glibc, gawk, diffutils }:

stdenv.mkDerivation rec {
  pname = "clamav-unofficial-sigs";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "extremeshok";
    repo = "clamav-unofficial-sigs";
    rev = version;
    sha256 = "sha256-utGr7phrLyZojTVg1V2MnlhYmCBP6K6L4OYfug+/5D0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/etc/clamav-unofficial-sigs

    cp clamav-unofficial-sigs.sh $out/bin/clamav-unofficial-sigs
    chmod +x $out/bin/clamav-unofficial-sigs

    cp config/master.conf $out/etc/clamav-unofficial-sigs

    echo '
    allow_upgrades="no"
    allow_update_checks="no"
    clam_user="clamav"
    clam_group="clamav"
    clamd_pid="/run/clamav/clamd.pid"
    clamd_socket="/run/clamav/clamd.ctl"
    log_pipe_cmd="systemd-cat -t clamav-unofficial-sigs"
    enable_random="no"
    user_configuration_complete="yes"
    ' > $out/etc/clamav-unofficial-sigs/os.conf

    wrapProgram $out/bin/clamav-unofficial-sigs \
      --prefix PATH : "${stdenv.lib.makeBinPath [ clamav coreutils gzip rsync gnutar gnugrep curl dnsutils gnupg glibc gawk diffutils ]}"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/extremeshok/clamav-unofficial-sigs";
    description = "ClamAV Unofficial Signatures Updater";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ SlothOfAnarchy ];
    platforms = platforms.linux;
  };
}
