{ lib, stdenv, fetchFromGitHub, docutils, installShellFiles }:

stdenv.mkDerivation {
  pname = "netevent";
  version = "20201018";

  src = fetchFromGitHub {
    owner = "Blub";
    repo = "netevent";
    rev = "ddd330f0dc956a95a111c58ad10546071058e4c1";
    sha256 = "0myk91pmim0m51h4b8hplkbxvns0icvfmv0401r0hw8md828nh5c";
  };

  buildInputs = [ docutils ];
  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "doc" "man" ];

  configurePhase = ''
    export RST2MAN=rst2man
    ./configure
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 netevent $out/bin/

    installManPage doc/netevent.1

    mkdir -p $doc/share/doc/netevent
    cp doc/netevent.rst $doc/share/doc/netevent/netevent.rst
  '';

  meta = with lib; {
    description = "Share linux event devices with other machines";
    homepage = "https://github.com/Blub/netevent";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
