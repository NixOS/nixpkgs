{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "acpid-2.0.31";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/${name}.tar.xz";
    sha256 = "1hrc0xm6q12knbgzhq0i8g2rfrkwcvh1asd7k9rs3nc5xmlwd7gw";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # remove when https://sourceforge.net/p/acpid2/code/merge-requests/1/ is merged
  postPatch = ''
    substituteInPlace configure.ac \
      --replace "AC_FUNC_MALLOC" "" \
      --replace "AC_FUNC_REALLOC" "" \
      --replace "strrchr strtol" "strrchr strtol malloc realloc"
  '';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/acpid2/;
    description = "A daemon for delivering ACPI events to userspace programs";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
