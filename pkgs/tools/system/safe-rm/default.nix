{ stdenv, fetchgit, perl, coreutils }:

stdenv.mkDerivation rec {
  pname = "safe-rm";
  version = "0.12";

  src = fetchgit {
    url = "https://git.launchpad.net/safe-rm";
    rev = "refs/tags/${pname}-${version}";
    sha256 = "0zkmwxyl1870ar6jr9h537vmqgkckqs9jd1yv6m4qqzdsmg5gdbq";
  };

  propagatedBuildInputs = [ perl coreutils ];

  postFixup = ''
    sed -e 's@/bin/rm@${coreutils}/bin/rm@' -i $out/bin/safe-rm
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp safe-rm $out/bin

    mkdir -p $out/share/man/man1
    pod2man safe-rm > $out/share/man/man1/safe-rm.1
  '';

  meta = with stdenv.lib; {
    description = "Tool intended to prevent the accidental deletion of important files";
    homepage = "https://launchpad.net/safe-rm";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}
