{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "dos2unix-2.2";
  
  src = fetchurl {
    url = http://cvs.fedoraproject.org/repo/pkgs/dos2unix/dos2unix-3.1.tar.bz2/f90026a397cf787083ec2e4892c6dcdd/dos2unix-3.1.tar.bz2;
    md5 = "f90026a397cf787083ec2e4892c6dcdd";
  };
  
  patches = [
    ./dos2unix-3.1.patch
    ./dos2unix-3.1-segfault.patch
    ./dos2unix-3.1-safeconv.patch
    ./dos2unix-3.1-manpage-update-57507.patch
    ./dos2unix-3.1-preserve-file-modes.patch
    ./dos2unix-3.1-tmppath.patch
    ./dos2unix-c-missing-arg.patch
    ./dos2unix-missing-proto.patch
    ./dos2unix-manpage.patch
    ./dos2unix-preserve-file-modes.patch
  ];

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/share/man/man1
    install -p -m755 dos2unix $out/bin
    install  -p -m644 dos2unix.1 $out/share/man/man1
    ln -s dos2unix $out/bin/mac2unix
  '';

  buildPhase = ''
    rm -f dos2unix
    make dos2unix
  '';

  meta = {
    homepage = http://unknown/;
    description = "dos2unix tool";
  };
}
