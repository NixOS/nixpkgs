{ stdenv, fetchgit, cmake, libtiff, pkgconfig, tesseract }:

let rev = "b70b6f584e8151f70f9d90df054af0911ea7475e";
    shortRev = builtins.substring 0 7 rev;
in
stdenv.mkDerivation {
  name = "vobsub2srt-git-20140226-${shortRev}";

  src = fetchgit {
    inherit rev;
    url = https://github.com/ruediger/VobSub2SRT.git;
    sha256 = "15437eba07e674cec66bc54cfa42ffe8b05816975401c9950bf9016e3881cd6a";
  };

  buildInputs = [ cmake libtiff pkgconfig ];
  propagatedBuildInputs = [ tesseract ];

  meta = {
    homepage = https://github.com/ruediger/VobSub2SRT;
    description = "Converts VobSub subtitles into SRT subtitles";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };
}
