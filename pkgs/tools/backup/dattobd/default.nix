{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "${pname}-${version}";
  pname = "dattobd";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "datto";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fw74b7m3qwd5lfg5vx530n9w02ig6gamzq74hw0rxjp43jmkxx3";
  };

  postPatch = ''
    patchShebangs src/genconfig.sh
  '';

  meta = with stdenv.lib; {
    description = "Kernel module for snapshots and incremental backups of Linux block devices";
    homepage = https://github.com/datto/dattobd;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };

}
