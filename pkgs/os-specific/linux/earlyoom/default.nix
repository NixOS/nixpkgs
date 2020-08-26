{ stdenv, fetchFromGitHub, pandoc, installShellFiles, withManpage ? false }:

stdenv.mkDerivation rec {
  pname = "earlyoom";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${version}";
    sha256 = "1cn0bgbgiq69i8mk8zxly1f7j01afm82g672qzccz6swsi2637j4";
  };

  nativeBuildInputs = stdenv.lib.optionals withManpage [ pandoc installShellFiles ];

  patches = [ ./fix-dbus-path.patch ];

  makeFlags = [ "VERSION=${version}" ];

  installPhase = ''
    install -D earlyoom $out/bin/earlyoom
  '' + stdenv.lib.optionalString withManpage ''
    installManPage earlyoom.1
  '';

  meta = with stdenv.lib; {
    description = "Early OOM Daemon for Linux";
    homepage = "https://github.com/rfjakob/earlyoom";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
