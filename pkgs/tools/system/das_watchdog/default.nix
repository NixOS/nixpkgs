{ lib, stdenv, fetchFromGitHub, libgtop, xmessage, which, pkg-config }:

stdenv.mkDerivation {
  pname = "das_watchdog";
  version = "unstable-2015-09-12";

  src = fetchFromGitHub {
    owner = "kmatheussen";
    repo = "das_watchdog";
    rev = "5ac0db0b98e5b4e690aca0aa7fb6ec60ceddcb06";
    sha256 = "sha256-eacUn/gYCEHtHdQf3lBPYvY3kfN3Bik7AolAPpbbwQs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgtop xmessage which ];

  installPhase = ''
    mkdir -p $out/bin/
    cp das_watchdog $out/bin/
    cp test_rt $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/kmatheussen/das_watchdog";
    description = "General watchdog for the linux operating system";
    longDescription = ''
      It should run in the background at all times to ensure a realtime process
      won't hang the machine.";
    '';
    license = licenses.free;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
