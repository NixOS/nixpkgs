args: with args;

# !!! What does this package do, and does it belong in Nixpkgs?

stdenv.mkDerivation {
	name = "xlaunch";
	inherit xorgserver;
	buildCommand = "
		cat << EOF > realizeuid.c
		#include <sys/types.h>
		#include <unistd.h>
		#include <stdio.h>
		int main(int argc, char ** argv, char ** envp)
		{
			uid_t a,b,c;
			int i;
			char *nargv[10000];
			char arg1 [10];
			nargv[0]=argv[0];
			for (i=1; i<=argc; i++){
				nargv[i+1]=argv[i];
			}
			nargv[1]=arg1;
			getresuid (&a,&b,&c);
			snprintf(arg1,8,\"%d\",a);
			setresuid(c,c,c);
			execve(\"\$out/libexec/xlaunch\", nargv, envp);
		}
EOF
		mkdir -p \$out/bin
		mkdir -p \$out/libexec
		gcc realizeuid.c -o \$out/bin/xlaunch
		echo '#! ${stdenv.shell}
			USER=\$(egrep '\\''^[-a-z0-9A-Z_]*:[^:]*:'\\''\$1'\\'':'\\'' /etc/passwd | sed -e '\\''s/:.*//'\\'' )
			shift
			case \"\$1\" in 
				:*) export _display=\"\$1\"; 
				shift
			esac
			_display=\${_display:-:0}
			_display=\${_display#:}
			echo Using :\$_display
			if [ -n \"\$DO_X_RESET\" ]; then 
			  RESET_OPTION=\"-once\"
			else
			  RESET_OPTION=\"-noreset\"
			fi;
			XCMD=\"\$(egrep \"^env\" /etc/event.d/xserver | sed -e \"s/env/ export /\" | sed -e '\\''s/#.*//'\\'' ; echo export _XARGS_=\\\$\\( grep xserver_arguments \\\$SLIM_CFGFILE \\| sed -e s/xserver_arguments// \\| sed -e s/:0/:\${_display}/ \\| sed -e s/vt7/vt\$((7+_display))/ \\) ; echo ${xorgserver}/bin/X \\\$_XARGS_ \$RESET_OPTION )\" 
			echo \"\$XCMD\" 
			echo \"\$XCMD\" | bash &
			while ! test -e /tmp/.X11-unix/X\$_display &>/dev/null ; do sleep 0.5; done
			su -l \${USER:-identityless-shelter} -c \"DISPLAY=:\$_display \$*\";
		' >\$out/libexec/xlaunch
		chmod a+x \$out/libexec/xlaunch
	";
}
