args:
	with args;
stdenv.mkDerivation
{
	name="X11-fonts";
	phases="installPhase";
	fontDirs = import ./fonts.nix {inherit pkgs config;};	
	buildInputs = [mkfontdir mkfontscale];
	inherit fontalias;
	installCommand = "
		list='';
		for i in \$fontDirs ; do
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
		cat \$( find \$fontalias/ -name fonts.alias) >fonts.alias
	";
}
