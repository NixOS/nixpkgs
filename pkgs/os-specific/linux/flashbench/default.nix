{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "flashbench";
  version = "2012-06-06";

  src = fetchgit {
    url = "https://github.com/bradfa/flashbench.git";
    rev = "2e30b1968a66147412f21002ea844122a0d5e2f0";
    sha256 = "037rhd2alwfip9qk78cy8fwwnc2kdyzccsyc7v2zpmvl4vvpvnhg";
  };

  installPhase = ''
    install -d -m755 $out/bin $out/share/doc/flashbench
    install -v -m755 flashbench $out/bin
    install -v -m755 erase $out/bin/flashbench-erase
    install -v -m644 README $out/share/doc/flashbench
  '';

  meta = with stdenv.lib; {
    description = "Testing tool for flash based memory devices";
    homepage = https://github.com/bradfa/flashbench;
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.rycee ];
  };
}
