{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "unstable-2019-12-25";
  pname = "hdl_dump";

  src = fetchFromGitHub {
    owner = "AKuHAK";
    repo = "hdl-dump";
    rev = "299aec48c5fffe31b0dc3a35d490eeacac3bd066";
    sha256 = "18pahyf4c823g4ar6kmz5m8wfkf9gc5lgciqh14ni8qmkb3mc0gg";
  };

  installPhase = ''
    install -Dm755 hdl_dump -t $out/bin
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "PlayStation 2 HDLoader image dump/install utility";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ genesis ];
  };
}
