{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "acpid";
  version = "2.0.33";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/acpid-${version}.tar.xz";
    sha256 = "sha256-CFb3Gz6zShtmPQqOY2Pfy8UZ5j2EczBJiJhljily2+g=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # remove when https://sourceforge.net/p/acpid2/code/merge-requests/1/ is merged
  postPatch = ''
    substituteInPlace configure.ac \
      --replace "AC_FUNC_MALLOC" "" \
      --replace "AC_FUNC_REALLOC" "" \
      --replace "strrchr strtol" "strrchr strtol malloc realloc"
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/acpid2/";
    description = "A daemon for delivering ACPI events to userspace programs";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
