args:
	with args;
stdenv.mkDerivation
{
	name="X11-fonts";
	phases="installPhase";
	fontDirs = import ./fonts.nix {inherit pkgs config;};	
	installCommand = "
		mkdir -p \$out/share/X11-fonts/; 
		for i in \$fontDirs; do
			if ! echo \$i | egrep '~|/nix/var/nix/profiles' &>/dev/null; then
				j=\${i#/nix/store/}
				j=\${j%%/*}
				if ! test -e \$out/share/X11-fonts/\${j}; then
					ln -s \$i \$out/share/X11-fonts/\${j};
				fi;
			fi;
		done;
	";
}
