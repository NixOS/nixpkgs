{ stdenv, lib, fetchurl, guile, pkg-config }:

stdenv.mkDerivation rec {
  pname = "gnu-shepherd";
  version = "0.8.1";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/shepherd/shepherd-${version}.tar.gz";
    sha256 = "sha256-0y/lhpS7U1C1/HKFzwyg2cfSQiGqWWnWxGTuPjrIP3U=";
  };

  configureFlags = [
    "--localstatedir=/"
  ];

  buildInputs = [ guile ];
  nativeBuildInputs = [ pkg-config guile ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/shepherd/";
    description = "Service manager that looks after the herd of system services";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ kloenk ];
  };
}
