args: with args;
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
			(egrep \"^ +env\" /etc/event.d/xserver | sed -e \"s/env/ export /\" | sed -e '\\''s/#.*//'\\'' ; echo export _XARGS_=\\\$\\( grep xserver_arguments \\\$SLIM_CFGFILE \\| sed -e s/xserver_arguments//  \\) ; echo X \\\$_XARGS_ ) | bash -l &
			while ! test -e /tmp/.X11-unix/X0 &>/dev/null ; do sleep 0.5; done
			USER=\$(egrep '\\''^[-a-z0-9A-Z_]*:[^:]*:'\\''\$1'\\'':'\\'' /etc/passwd | sed -e '\\''s/:.*//'\\'' )
			shift
			su -l \${USER:-identityless-shelter} -c \"DISPLAY=:0 \$*\";
		' >\$out/libexec/xlaunch
		chmod a+x \$out/libexec/xlaunch
	";
}
