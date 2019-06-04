{ stdenv, fetchFromGitHub, autoreconfHook, expat, libaio, boost }:

stdenv.mkDerivation rec {
  pname = "thin-provisioning-tools";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fxmzjbnsb2xjawp9mkix398r0aiqzwdsbmyvxd7fdf4cyvqriis";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ expat libaio boost ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/jthornber/thin-provisioning-tools/;
    description = "A suite of tools for manipulating the metadata of the dm-thin device-mapper target";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
}
