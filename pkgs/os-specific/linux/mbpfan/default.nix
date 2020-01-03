{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mbpfan";
  version = "2.2.1";
  src = fetchFromGitHub {
    owner = "dgraziotin";
    repo = "mbpfan";
    rev = "v${version}";
    sha256 = "0gc9ypxi55vxs77nx8ihhh9zk7fr9v0m0zfm76q7x0bi6jz11mbr";
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
