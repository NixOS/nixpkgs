{ stdenv, fetchFromGitHub, makeWrapper
, bash, coreutils, gawk, gnugrep, which
, duplicity, gnupg
}:

stdenv.mkDerivation rec {
  name = "duplicity-backup-sh-${version}";
  version = "v1.3.0";

  src = fetchFromGitHub {
    owner = "zertrin";
    repo = "duplicity-backup.sh";
    rev = "${version}";
    sha256 = "0wswm91j2k457p067x07qgdwsjlxm5vqbs8nlg1hy4z02ihqriq6";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/duplicity-backup.sh"
    sed -i 's|/usr/bin/env bash|${bash}/bin/bash|' duplicity-backup.sh
    mv duplicity-backup.sh "$out/bin"
    wrapProgram "$out/bin/duplicity-backup.sh" \
      --prefix PATH : "${stdenv.lib.makeBinPath [
        bash coreutils gawk gnugrep which
        duplicity gnupg
      ]}"
    mv duplicity-backup.conf.example "$out/share/duplicity-backup.sh/"
  '';

  meta = with stdenv.lib; {
    description = "Bash wrapper script for automated backups with duplicity";
    longDescription = ''
      duplicity-backup.sh is a wrapper script derived from the
      dt-s3-backup.sh script of Damon Timm and designed to automate and
      simplify the remote backup process of duplicity on Amazon S3
      instances or other backup destinations.
    '';
    homepage = https://zertrin.org/projects/duplicity-backup/;
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
