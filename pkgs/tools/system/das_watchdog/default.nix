{ stdenv, fetchgit, libgtop, xmessage, which, pkgconfig }:

stdenv.mkDerivation rec {
  name = "das_watchdog-${version}";
  version = "git-2015-04-02";

  src = fetchgit {
    url = "https://github.com/kmatheussen/das_watchdog.git";
    rev = "1c203d9a55455c4670c164f945ea2dd9fd197ba9";
    sha256 = "c817491d67d31297dcd6177b9c33b5c3977c1c383eac588026631dd6961ba6bf";
  };

  buildInputs = [ libgtop xmessage which pkgconfig ];

  installPhase = ''
    mkdir -p $out/bin/
    cp das_watchdog $out/bin/
    cp test_rt $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kmatheussen/das_watchdog;
    description = "A general watchdog for the linux operating system";
    longDescription = ''
      It should run in the background at all times to ensure a realtime process
      won't hang the machine.";
    '';
    license = licenses.free;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
