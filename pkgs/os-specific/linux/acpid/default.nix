{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "acpid";
  version = "2.0.32";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/acpid-${version}.tar.xz";
    sha256 = "0zhmxnhnhg4v1viw82yjr22kram6k5k1ixznhayk8cnw7q5x7lpj";
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
