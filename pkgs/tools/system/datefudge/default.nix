{ stdenv, fetchgit, fetchpatch }:

stdenv.mkDerivation {
  pname = "datefudge";
  version = "1.23";

  src = fetchgit {
    url = "https://salsa.debian.org/debian/datefudge.git";
    rev = "090d3aace17640478f7f5119518b2f4196f62617";
    sha256 = "0r9g8v9xnv60hq3j20wqy34kyig3sc2pisjxl4irn7jjx85f1spv";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/datefudge/raw/master/f/datefudge_1.23-tz.patch";
      sha256 = "19c2fvhm06wnp3059b0rnd7dqdchkan8iycjh8jk8y25j870zkvn";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
     --replace "/usr" "/" \
     --replace "-o root -g root" ""
    substituteInPlace datefudge.sh \
     --replace "@LIBDIR@" "$out/lib/"
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = "chmod +x $out/lib/datefudge/datefudge.so";

  meta = with stdenv.lib; {
    description = "Fake the system date";
    longDescription = ''
      datefudge is a small utility that pretends that the system time is
      different by pre-loading a small library which modifies the time,
      gettimeofday and clock_gettime system calls.
    '';
    homepage = "https://packages.qa.debian.org/d/datefudge.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
