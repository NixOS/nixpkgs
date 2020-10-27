{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "outguess";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "outguess";
    rev = version;
    sha256 = "1wz0cpwg0r8sz46klhd78pmcbncmi2ih4r4ydb60l5vpjr1xf07j";
  };

  meta = with stdenv.lib; {
    description = "Universal steganographic tool";
    homepage = "https://github.com/resurrecting-open-source-projects/outguess";
    license = licenses.bsd2;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.linux;
  };
}
