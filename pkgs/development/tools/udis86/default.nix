{ lib, stdenv, fetchFromGitHub, autoreconfHook, python }:

stdenv.mkDerivation rec {
  pname = "udis86";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "vmt";
    repo = "udis86";
    rev = "v${version}";
    sha256 = "0c60zwimim6jrm4saw36s38w5sg5v8n9mr58pkqmjrlf7q9g6am1";
  };

  nativeBuildInputs = [ autoreconfHook python ];

  configureFlags = [
    "--enable-shared"
  ];

  outputs = [ "bin" "out" "dev" "lib" ];

  meta = with lib; {
    homepage = "http://udis86.sourceforge.net";
    license = licenses.bsd2;
    maintainers = with maintainers; [ timor ];
    description = ''
      Easy-to-use, minimalistic x86 disassembler library (libudis86)
    '';
    platforms = platforms.all;
  };
}
