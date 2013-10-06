{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.4.12";

  src = fetchurl {
    url = "http://www.ivarch.com/programs/sources/${name}.tar.bz2";
    sha256 = "0hnpv4l5kidfwxzba7ibm9wjs71ing9gzx0m80bgr3ia8k4s8nka";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
