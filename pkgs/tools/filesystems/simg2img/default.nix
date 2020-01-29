{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  pname = "simg2img";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "anestisb";
    repo = "android-simg2img";
    rev = version;
    sha256 = "119gl9i61g2wr07hzv6mi1ihql6yd6pwq94ki2pgcpfbamv8f6si";
  };

  buildInputs = [ zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Tool to convert Android sparse images to raw images";
    homepage = "https://github.com/anestisb/android-simg2img";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.dezgeg ];
  };
}
