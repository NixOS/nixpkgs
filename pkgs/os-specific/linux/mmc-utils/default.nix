{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "mmc-utils";
  version = "2019-10-04";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git";
    rev = "73d6c59af8d1bcedf5de4aa1f5d5b7f765f545f5";
    sha256 = "18a7qm86gavg15gv4h6xfnapgq24v4dyvhwfp53lkssxyhjbli0z";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    make install prefix=$out
    mkdir -p $out/share/man/man1
    cp man/mmc.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "Configure MMC storage devices from userspace";
    homepage = "http://git.kernel.org/cgit/linux/kernel/git/cjb/mmc-utils.git/";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
