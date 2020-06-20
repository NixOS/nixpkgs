{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.0.7";
  pname = "stenc";

  src = fetchFromGitHub {
    owner = "scsitape";
    repo = "stenc";
    rev = "${version}";
    sha256 = "1778m1zcyzyf42k5m496yqh0gv6kqhb0sq5983dhky1fccjl905k";
  };

  meta = {
    description = "SCSI Tape Encryption Manager";
    homepage = "https://github.com/scsitape/stenc";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ woffs ];
    platforms = stdenv.lib.platforms.linux;
  };
}
