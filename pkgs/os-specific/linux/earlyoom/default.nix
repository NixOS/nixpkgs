{ stdenv, fetchFromGitHub, pandoc, installShellFiles, withManpage ? false }:

stdenv.mkDerivation rec {
  pname = "earlyoom";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${version}";
    sha256 = "0g2bjsvnqq5h4g1k3a0x6ixb334wpzbm2gafl78b6ic6j45smwcs";
  };

  nativeBuildInputs = stdenv.lib.optionals withManpage [ pandoc installShellFiles ];

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
