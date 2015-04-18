{ stdenv, fetchgit, perl, coreutils }:

stdenv.mkDerivation rec {
  name = "safe-rm-${version}";
  version = "0.12";

  src = fetchgit {
    url = "https://gitorious.org/safe-rm/mainline.git";
    rev = "refs/tags/${name}";
    sha256 = "1n8ir96rwsg9r47lp3avl5sw548gvyh12zk5riflmmdvq907yi0s";
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
    homepage = https://launchpad.net/safe-rm;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}
