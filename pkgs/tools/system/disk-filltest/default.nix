{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "disk-filltest";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "bingmann";
    repo = "disk-filltest";
    rev = "v${version}";
    sha256 = "1vcb43hdln7xlklz1n0fsfp5x1j9pn829wbad4b110hrc7nwrnvm";
  };

  preBuild = ''
    substituteInPlace Makefile --replace 'prefix = /usr/local' 'prefix = $(out)'
  '';

  postInstall = ''
    install -D -m0644 -t $out/share/doc COPYING README
    mkdir -p $out/share/man; mv $out/man1 $out/share/man
  '';

  meta = with stdenv.lib; {
    description = "Simple program to detect bad disks by filling them with random data";
    longDescription = ''
      disk-filltest is a tool to check storage disks for coming
      failures by write files with pseudo-random data to the current
      directory until the disk is full, read the files again
      and verify the sequence written. It also can measure
      read/write speed while filling the disk.
    '';
    homepage = "https://panthema.net/2013/disk-filltest";
    license = licenses.gpl3;
    maintainers = with maintainers; [ caadar ];
    platforms = platforms.all;
  };

}
