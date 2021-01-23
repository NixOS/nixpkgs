{ lib, stdenv, fetchFromGitHub, btrfs-progs }:

stdenv.mkDerivation rec {
  pname = "compsize";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gk2vibfl9fh7biznlbr3dwknrwbm5q5602q95jbjvk185g9z126";
  };

  buildInputs = [ btrfs-progs ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8
    install -m 0755 compsize $out/bin
    install -m 0444 compsize.8 $out/share/man/man8
  '';

  meta = with lib; {
    description = "btrfs: Find compression type/ratio on a file or set of files";
    homepage    = "https://github.com/kilobyte/compsize";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms   = platforms.linux;
  };
}
