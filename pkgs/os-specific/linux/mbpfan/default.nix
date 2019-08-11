{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mbpfan-${version}";
  version = "2.1.1";
  src = fetchFromGitHub {
    owner = "dgraziotin";
    repo = "mbpfan";
    rev = "v${version}";
    sha256 = "0aijyxrqh01x0s80yr4cgxgd001iiqqph65pxvby7f0wz8lnxnqj";
  };
  installPhase = ''
    mkdir -p $out/bin $out/etc
    cp bin/mbpfan $out/bin
    cp mbpfan.conf $out/etc
  '';
  meta = with lib; {
    description = "Daemon that uses input from coretemp module and sets the fan speed using the applesmc module";
    homepage = https://github.com/dgraziotin/mbpfan;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
