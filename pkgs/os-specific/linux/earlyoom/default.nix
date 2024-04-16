{ lib, stdenv, fetchFromGitHub, pandoc, installShellFiles, withManpage ? false, nixosTests }:

stdenv.mkDerivation rec {
  pname = "earlyoom";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${version}";
    sha256 = "sha256-jgNoYOGor2i3ngDuU3It238n5ky+AppzlRKdkwXb2AI=";
  };

  nativeBuildInputs = lib.optionals withManpage [ pandoc installShellFiles ];

  patches = [ ./fix-dbus-path.patch ];

  makeFlags = [ "VERSION=${version}" ];

  installPhase = ''
    install -D earlyoom $out/bin/earlyoom
  '' + lib.optionalString withManpage ''
    installManPage earlyoom.1
  '';

  passthru.tests = {
    inherit (nixosTests) earlyoom;
  };

  meta = with lib; {
    description = "Early OOM Daemon for Linux";
    mainProgram = "earlyoom";
    homepage = "https://github.com/rfjakob/earlyoom";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
