{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dro2imf";
  version = "1.2";

  src = fetchFromGitHub {
    repo = name;
    owner = "Malvineous";
    rev = "2ff00b3b988784b27b8991a459b7488f94733fa2";
    sha256 = "18vp5yn76fafjqpi6rp7adygy5s8g5526nwpzz14gxmpzk4s5k8h";
  };

  installPhase = ''
    install -Dm755 dro2imf $out/bin/dro2imf
  '';

  meta = with stdenv.lib; {
    homepage = http://www.shikadi.net/utils/dro2imf;
    description = "Convert DOSBox OPL captures (.dro) into id Software .imf format ";
    license = licenses.free;
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}

