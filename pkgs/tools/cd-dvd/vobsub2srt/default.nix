{ stdenv, fetchgit, cmake, libtiff, pkgconfig, tesseract }:

let rev = "a6abbd61127a6392d420bbbebdf7612608c943c2";
    shortRev = builtins.substring 0 7 rev;
in
stdenv.mkDerivation {
  name = "vobsub2srt-git-20140817-${shortRev}";

  src = fetchgit {
    inherit rev;
    url = https://github.com/ruediger/VobSub2SRT.git;
    sha256 = "8e867a021ac529e7607627d5944b95bb9f1378ffabd8837e7a028663a8ce5adf";
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
