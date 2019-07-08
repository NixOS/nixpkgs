{ stdenv, fetchFromGitHub, btrfs-progs }:

stdenv.mkDerivation rec {
  pname = "compsize";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = "compsize";
    rev = "v${version}";
    sha256 = "1c69whla844nwis30jxbj00zkpiw3ccndhkmzjii8av5358mjn43";
  };

  buildInputs = [ btrfs-progs ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8
    install -m 0755 compsize $out/bin
    install -m 0444 compsize.8 $out/share/man/man8
  '';

  meta = with stdenv.lib; {
    description = "btrfs: Find compression type/ratio on a file or set of files";
    homepage    = https://github.com/kilobyte/compsize;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms   = platforms.linux;
  };
}
