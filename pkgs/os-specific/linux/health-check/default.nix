{ stdenv, lib, fetchFromGitHub, json_c, libbsd }:

stdenv.mkDerivation rec {
  pname = "health-check";
  version = "0.03.11";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-QLa/7kA0juefzOba7ELopDmOVfiGJReo4LCfhnxW1tk=";
  };

  buildInputs = [ json_c libbsd ];

  makeFlags = [ "JSON_OUTPUT=y" "FNOTIFY=y" ];

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Process monitoring tool";
    homepage = "https://github.com/ColinIanKing/health-check";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
