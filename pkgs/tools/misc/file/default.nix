{stdenv, fetchurl}:
 
stdenv.mkDerivation rec {
  name = "file-5.12";

  src = fetchurl {
    url = "ftp://ftp.astron.com/pub/file/${name}.tar.gz";
    sha256 = "08ix4xrvan0k80n0l5lqfmc4azjv5lyhvhwdxny4r09j5smhv78r";
  };

  meta = {
    description = "A program that shows the type of files";
    homepage = http://www.darwinsys.com/file/;
  };
}
