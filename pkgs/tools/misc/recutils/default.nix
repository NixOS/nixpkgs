{ fetchurl, stdenv, emacs, curl, check, bc }:

stdenv.mkDerivation rec {
  name = "recutils-1.7";

  src = fetchurl {
    url = "mirror://gnu/recutils/${name}.tar.gz";
    sha256 = "0cdwa4094x3yx7vn98xykvnlp9rngvd58d19vs3vh5hrvggccg93";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ curl emacs ];

  checkInputs = [ check bc ];
  doCheck = true;

  # one file fails to compile with emacs 26
  postInstall = ''
    ${emacs}/bin/emacs -Q -batch -f batch-byte-compile $out/share/emacs/site-lisp/*.el || true
  '';

  meta = {
    description = "Tools and libraries to access human-editable, text-based databases";

    longDescription =
      '' GNU Recutils is a set of tools and libraries to access
         human-editable, text-based databases called recfiles.  The data is
         stored as a sequence of records, each record containing an arbitrary
         number of named fields.
      '';

    homepage = http://www.gnu.org/software/recutils/;

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
