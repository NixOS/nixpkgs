args:
args.stdenv.mkDerivation {
  name = "xmacro";

  src = args.fetchurl {
    url = mirror://sourceforge/xmacro/xmacro-pre0.3-20000911.tar.gz;
    md5 = "d2956b82f3d5380e58a75ccc721fb746";
  };

  preBuild=" sed -e 's/-pedantic//g' -i Makefile ";

  preInstall="echo -e 'install:\n	mkdir \${out}/bin;\n	cp xmacrorec xmacrorec2 xmacroplay \${out}/bin;' >>Makefile; ";

  buildInputs = (with args; 
	[libX11 libXtst xextproto libXi inputproto]);
}
