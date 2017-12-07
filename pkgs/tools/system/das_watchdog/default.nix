{ stdenv, fetchgit, libgtop, xmessage, which, pkgconfig }:

stdenv.mkDerivation rec {
  name = "das_watchdog-${version}";
  version = "git-2015-09-12";

  src = fetchgit {
    url = "https://github.com/kmatheussen/das_watchdog.git";
    rev = "5ac0db0b98e5b4e690aca0aa7fb6ec60ceddcb06";
    sha256 = "02y1vfb3wh4908xjj1kpyf8kgxk29x8dw7yl3pnl220qz2gi99vr";
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
