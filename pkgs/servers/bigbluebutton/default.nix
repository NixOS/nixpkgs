{ stdenv, fetchFromGitHub, gradle }:

stdenv.mkDerivation rec {
  pname = "bigbluebutton";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "bigbluebutton";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rrf0d6hcnz5f6pday3r3pxn9yjgaram3fq260ya4scxcymd416h";
  };

  nativeBuildInputs = [ gradle ];

  # See the build script:
  # https://github.com/bigbluebutton/bigbluebutton/blob/develop/bbb.sh
  buildPhase = ''
    pushd bigbluebutton-apps
    gradle --offline resolveDeps
    gradle --offline clean war deploy
    popd
  '';

  meta = with stdenv.lib; {
    description = "Web conferencing system designed for online learning";
    homepage = "https://bigbluebutton.org/";
    # There seems to be different licenses in the repo:
    # https://github.com/bigbluebutton/bigbluebutton/search?q=license&unscoped_q=license
    #
    # On the other hand, it is said here that the license is LGPL (which
    # version?): https://bigbluebutton.org/open-source-license/
    #
    # At least these licenses could be found in the source files:
    license = with licenses; [ gpl3 asl20 lgpl3Plus gpl2Plus mit ];
    maintainers = with maintainers; [ jluttine ];
  };
}
