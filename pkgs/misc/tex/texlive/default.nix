args : with args; with builderDefs {src="";} null;
	let localDefs = builderDefs (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = debian://pool/main/t/texlive-bin/texlive-bin_2007.orig.tar.gz;
			sha256 = "1fz5lqbigdrdg0pmaynissd7wn59p2yj9f203nl93dcpffrapxjv";
		};
		texmfSrc = 
		fetchurl {
			url = debian://pool/main/t/texlive-base/texlive-base_2007.orig.tar.gz;
			sha256 = "16a4dyliidk43qj0m4gpsl9ln7nqsdcdx1lkbk4wrm03xpx87zvh";
		};

		setupHook = ./setup-hook.sh;

		doInstall = FullDepEntry (''
			ensureDir $out
			ensureDir $out/nix-support 
			cp ${setupHook} $out/nix-support/setup-hook.sh
			ensureDir $out/share
			tar xf ${texmfSrc} -C $out/share --strip-components=1
			cd build/source
			sed -e s@/usr/bin/@@g -i $(grep /usr/bin/ -rl . )
			sed -e '/ubidi_open/i#include <unicode/urename.h>' -i $(find . -name configure)
			sed -e s@ncurses/curses.h@curses.h@g -i $(grep ncurses/curses.h -rl . ) 
			NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2"
			echo NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${icu}/include/unicode"
			NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${icu}/include/layout";
			./configure --prefix=$out \
				--with-x11 \
				--with-system-zlib \
				--with-system-freetype2 \
				--with-system-t1lib \
				--with-system-pnglib \
				--with-system-gd \
				--with-system-icu \
				--with-system-ncurses \
				--enable-ipc \
				--with-mktexfmt
			make 
			make install
			mv $out/bin $out/libexec
			ensureDir $out/bin
			for i in $out/libexec/*/*; do
				echo -ne "#! /bin/sh\\n$i \"\$@\"" >$out/bin/$(basename $i)
				chmod a+x $out/bin/$(basename $i)
			done
			texmf_var=$(mktemp -d /var/tmp/texmf-varXXXXXXXX)
			mv $out/share/texmf-var/* $texmf_var/ 			
			chmod -R a+rwX $texmf_var
			ln -s $texmf_var $out/share/texmf-var
			ln -s $out/share/texmf $out/share/texmf-config
		'') ["minInit" "defEnsureDir" "doUnpack" "addInputs"];
		buildInputs = [zlib bzip2 ncurses libpng ed flex bison libX11 xproto 
			freetype t1lib gd libXaw icu ghostscript 
			libXt libXpm libXmu libXext xextproto perl libSM 
			libICE];
		configureFlags = [];
	}) args null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "TeXLive-core-2007";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doInstall doForceShare doPropagate]);
	meta = {
		description = "
		TeX distribution.
";
		inherit src;
		srcs = [texmfSrc];
	};
}
