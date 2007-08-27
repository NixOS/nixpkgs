args:
args.stdenv.mkDerivation {
  name = "wv-1.2.4";

  src = args.
	fetchurl {
		url = mirror://sourceforge/wvware/wv-1.2.4.tar.gz;
		sha256 = "1mn2ax6qjy3pvixlnvbkn6ymy6y4l2wxrr4brjaczm121s8hjcb7";
	};

  buildInputs =(with args; [zlib imagemagick libpng glib
	pkgconfig libgsf libxml2]);

  meta = {
    description = "
	Convertor from Microsoft Word formats to human-editable ones.
";
  };
}
