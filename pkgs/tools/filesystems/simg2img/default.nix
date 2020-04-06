{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  pname = "simg2img";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "anestisb";
    repo = "android-simg2img";
    rev = version;
    sha256 = "1xm9kaqs2w8c7a4psv78gv66gild88mpgjn5lj087d7jh1jxy7bf";
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
