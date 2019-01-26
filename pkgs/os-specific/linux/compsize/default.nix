{ stdenv, fetchFromGitHub, btrfs-progs }:

stdenv.mkDerivation rec {
  name = "compsize-${version}";
  version = "2018-04-07";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = "compsize";
    rev = "903f772e37fc0ac6d6cf94ddbc98c691763c1e62";
    sha256 = "0jps8n0xsdh4mcww5q29rzysbv50iq6rmihxrf99lzgrw0sw5m7k";
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
