args : with args; with builderDefs {src="";} null;
	let localDefs = builderDefs rec {
		src = "";/* put a fetchurl here */

		buildInputs = [mkfontdir mkfontscale];
		configureFlags = [];
		fontDirs = import ./fonts.nix {inherit pkgs config;};
		installPhase = FullDepEntry ("
		list='';
		for i in ${toString fontDirs} ; do
			if [ -d \$i/ ]; then
				list=\"\$list \$i\";
			fi;
		done
		list=\$(find \$list -name fonts.dir);
		fontDirs='';
		for i in \$list ; do
			fontDirs=\"\$fontDirs \$(dirname \$i)\";
		done;
		mkdir -p \$out/share/X11-fonts/; 
		for i in \$(find \$fontDirs -type f -o -type l); do
			j=\${i##*/}
			if ! test -e \$out/share/X11-fonts/\${j}; then
				ln -s \$i \$out/share/X11-fonts/\${j};
			fi;
		done;
		cd \$out/share/X11-fonts/
		rm fonts.dir
		rm fonts.scale
		rm fonts.alias
		mkfontdir
		mkfontscale
		cat \$( find ${fontalias}/ -name fonts.alias) >fonts.alias
	") ["minInit" "addInputs"];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "X11-fonts";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[installPhase doForceShare doPropagate]);
	meta = {
		description = "
		Directory to contain all X11 fonts requested.
";
	};
}
