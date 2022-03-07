{ lib, stdenv, fetchFromGitHub, pandoc, installShellFiles, withManpage ? false }:

stdenv.mkDerivation rec {
  pname = "earlyoom";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${version}";
    sha256 = "sha256-8YcT1TTlAet7F1U9Ginda4IApNqkudegOXqm8rnRGfc=";
  };

  nativeBuildInputs = lib.optionals withManpage [ pandoc installShellFiles ];

  patches = [ ./fix-dbus-path.patch ];

  makeFlags = [ "VERSION=${version}" ];

  installPhase = ''
    install -D earlyoom $out/bin/earlyoom
  '' + lib.optionalString withManpage ''
    installManPage earlyoom.1
  '';

  meta = with lib; {
    description = "Early OOM Daemon for Linux";
    homepage = "https://github.com/rfjakob/earlyoom";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
