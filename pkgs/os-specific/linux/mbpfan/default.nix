{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mbpfan";
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "dgraziotin";
    repo = "mbpfan";
    rev = "v${version}";
    sha256 = "sha256-jIYg9b0c/7mMRS5WF+mOH6t9SCWEP32lsdbCgpWpg24=";
  };
  installPhase = ''
    mkdir -p $out/bin $out/etc
    cp bin/mbpfan $out/bin
    cp mbpfan.conf $out/etc
  '';
  meta = with lib; {
    description = "Daemon that uses input from coretemp module and sets the fan speed using the applesmc module";
    homepage = "https://github.com/dgraziotin/mbpfan";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
