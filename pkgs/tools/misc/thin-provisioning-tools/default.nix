{ stdenv, fetchFromGitHub, autoreconfHook, expat, libaio, boost }:

stdenv.mkDerivation rec {
  pname = "thin-provisioning-tools";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m0vngy619mm6bzmkd4n363yab9lvxan2wsbx1y7g0vaf5s33nhr";
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
