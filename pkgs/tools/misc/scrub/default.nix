{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "scrub";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "chaos";
    repo = "scrub";
    rev = version;
    sha256 = "0ndcri2ddzqlsxvy1b607ajyd4dxpiagzx331yyi7hf3ijph129f";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libtool ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    description = "Disk overwrite utility";
    homepage = "https://github.com/chaos/scrub";
    changelog = "https://raw.githubusercontent.com/chaos/scrub/master/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ j0hax ];
    platforms = platforms.unix;
    mainProgram = "scrub";
  };
}
