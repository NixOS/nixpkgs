args: with args;
stdenv.mkDerivation {
	name = "upstart-jobcontrol";
	buildCommand = "
		mkdir -p \$out/bin
		echo '
			file=/etc/event.d/\$1
			shift
			controlscript=\$(egrep exec\\|respawn \$file | tail | sed -e s/^\\\\s\\\\+//g  | sed -e s/\\\\s\\\\+/\\ /g | cut -f 2 -d \\  )
			echo Running \$controlscript \"\$@\"
			\$controlscript \"\$@\"
		' >\$out/bin/jobcontrol
		chmod a+x \$out/bin/jobcontrol
	";
}
