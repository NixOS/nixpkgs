{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "schedtool";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "freequaos";
    repo = "schedtool";
    rev = "${pname}-${version}";
    sha256 = "1wdw6fnf9a01xfjhdah3mn8bp1bvahf2lfq74i6hk5b2cagkppyp";
  };

  makeFlags = [ "DESTDIR=$(out)" "DESTPREFIX=" ];

  meta = with lib; {
    description = "Query or alter a process' scheduling policy under Linux";
    mainProgram = "schedtool";
    homepage = "https://freequaos.host.sk/schedtool/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
