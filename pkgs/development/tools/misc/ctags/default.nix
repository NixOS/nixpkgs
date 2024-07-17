{
  lib,
  stdenv,
  fetchsvn,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "ctags";
  version = "816";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/ctags/code/trunk";
    rev = version;
    sha256 = "0jmbkrmscbl64j71qffcc39x005jrmphx8kirs1g2ws44wil39hf";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # don't use $T(E)MP which is set to the build directory
  configureFlags = [ "--enable-tmpdir=/tmp" ];

  patches = [
    # Library defines an `__unused__` which is a reserved name, and may
    # conflict with the standard library definition. One such conflict is with
    # macOS headers.
    ./unused-collision.patch
  ];

  meta = with lib; {
    description = "A tool for fast source code browsing (exuberant ctags)";
    mainProgram = "ctags";
    longDescription = ''
      Ctags generates an index (or tag) file of language objects found
      in source files that allows these items to be quickly and easily
      located by a text editor or other utility.  A tag signifies a
      language object for which an index entry is available (or,
      alternatively, the index entry created for that object).  Many
      programming languages are supported.
    '';
    homepage = "https://ctags.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;

    # So that Exuberant ctags is preferred over emacs's ctags
    priority = 1;
  };

}
