{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name = "android-simg2img-${version}";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "anestisb";
    repo  = "android-simg2img";
    rev   = "02777ee356ecc38efcd480f8da535755d598cc30";
    sha256 = "119gl9i61g2wr07hzv6mi1ihql6yd6pwq94ki2pgcpfbamv8f6si";
  };

  buildInputs = [ zlib ];

  installPhase = ''
      PREFIX="$out" make install
  '';

  meta = with stdenv.lib; {
    description = "Tool to convert Android sparse images to raw images";
    longDescription = ''
      Tool to convert Android sparse images to raw images.
      Since image tools are not part of Android SDK, this standalone port of AOSP libsparse aims to avoid complex building chains.
    '';
    homepage = https://github.com/anestisb/android-simg2img;
    license = licenses.asl20;
    maintainers = [ maintainers.alexchapman ];
    platforms = platforms.all;
  };
}
