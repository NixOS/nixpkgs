{ stdenv, fetchFromGitHub, autoreconfHook, expat, libaio, boost }:

stdenv.mkDerivation rec {
  name = "thin-provisioning-tools-${version}";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = "thin-provisioning-tools";
    rev = "v${version}";
    sha256 = "1ibg5wxrbqg4pr3f6aacqm42fxpwn5q00j8ldy9mw4an3ck41cwa";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ expat libaio boost ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jthornber/thin-provisioning-tools/;
    description = "A suite of tools for manipulating the metadata of the dm-thin device-mapper target";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
}
