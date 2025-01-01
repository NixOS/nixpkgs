#TODO@deliciouslytyped The tool seems to unnecessarily force mutable access for the debugedit `-l` feature
{fetchgit, lib, stdenv, autoreconfHook, pkg-config, elfutils, help2man, util-linux}:
stdenv.mkDerivation rec {
  pname = "debugedit";
  version = "5.0";

  nativeBuildInputs = [ autoreconfHook pkg-config help2man ];
  buildInputs = [ elfutils ];
  nativeCheckInputs = [ util-linux ]; # Tests use `rev`

  src = fetchgit {
    url = "git://sourceware.org/git/debugedit.git";
    rev = "debugedit-${version}";
    sha256 = "VTZ7ybQT3DfKIfK0lH+JiehCJyJ+qpQ0bAn1/f+Pscs=";
  };

  preBuild = ''
    patchShebangs scripts/find-debuginfo.in
  '';

  doCheck = true;

  meta = with lib; {
    description = "Provides programs and scripts for creating debuginfo and source file distributions, collect build-ids and rewrite source paths in DWARF data for debugging, tracing and profiling";
    homepage = "https://sourceware.org/debugedit/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ deliciouslytyped ];
  };
}
