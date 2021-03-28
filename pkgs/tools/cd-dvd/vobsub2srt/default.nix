{ lib, stdenv, fetchgit, cmake, libtiff, pkg-config, tesseract }:

let rev = "a6abbd61127a6392d420bbbebdf7612608c943c2";
    shortRev = builtins.substring 0 7 rev;
in
stdenv.mkDerivation {
  name = "vobsub2srt-git-20140817-${shortRev}";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/ruediger/VobSub2SRT.git";
    sha256 = "1rpanrv8bgdh95v2320qbd44xskncvq6y84cbbfc86gw0qxpd9cb";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libtiff ];
  propagatedBuildInputs = [ tesseract ];

  meta = {
    homepage = "https://github.com/ruediger/VobSub2SRT";
    description = "Converts VobSub subtitles into SRT subtitles";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
