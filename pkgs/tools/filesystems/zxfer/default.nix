{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, coreutils
, gnused
, gawk
, gnugrep
, openssh
, rsync
}:

stdenv.mkDerivation rec {
  pname = "zxfer";
  version = "1.1.7";

  src = fetchFromGitHub {
    repo = "zxfer";
    owner = "allanjude";
    rev = "v${version}";
    sha256 = "11SQJcD3GqPYBIgaycyKkc62/diVKPuuj2Or97j+NZY=";
  };

  nativeBuildInputs = [
   installShellFiles
  ];

  buildInputs = [
    coreutils
    gawk
    gnused
    gnugrep
    openssh
    rsync
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp zxfer $out/bin/

    installManPage zxfer.8
  '';

  meta = with lib; {
    homepage = "https://github.com/allanjude/zxfer";
    description = "Transfer ZFS filesystems, snapshots, properties, files and directories";
    longDescription = ''
      Transfer a source zfs filesystem, directory or files to a destination, using
      either zfs send/receive or rsync to do the heavy lifting.
    '';
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pbsds ];
  };
}
