{ stdenv, lib, fetchFromGitHub, makeWrapper, clamav, rsync, coreutils, gnutar, curl, gzip, dnsutils, gnupg, glibc, gawk, diffutils, bind }:

stdenv.mkDerivation rec {
  pname = "clamav-unofficial-sigs";
  version = "7.2";

  src = fetchFromGitHub {
    owner = "extremeshok";
    repo = "clamav-unofficial-sigs";
    rev = "${version}";
    sha256 = "sha256-KZh8f4BB31b4ZBOrp4z/+TCqsppa2cyfteM3OUVv57A=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/etc/clamav-unofficial-sigs
    mkdir -p $out/bin

    cp clamav-unofficial-sigs.sh $out/bin
    chmod +x $out/bin/clamav-unofficial-sigs.sh

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

    wrapProgram $out/bin/clamav-unofficial-sigs.sh --prefix PATH : "${lib.makeBinPath [ clamav coreutils gzip rsync gnutar curl dnsutils bind.host gnupg glibc gawk diffutils ]}"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/extremeshok/clamav-unofficial-sigs";
    description = "ClamAV Unofficial Signatures Updater";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ SlothOfAnarchy ];
    platforms = platforms.linux;
  };
}
