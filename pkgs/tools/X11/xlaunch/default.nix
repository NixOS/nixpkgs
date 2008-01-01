args: with args;
stdenv.mkDerivation {
	name = "xlaunch";
	inherit xorgserver;
	buildCommand = "
		mkdir -p \$out/bin
		echo '
			(egrep \"^ +env\" /etc/event.d/xserver | sed -e \"s/env/ export /\" ; echo X;) | bash &
			sleep 15; 
			\"$@\";
		' >\$out/bin/xlaunch
		chmod a+x \$out/bin/xlaunch
	";
}
