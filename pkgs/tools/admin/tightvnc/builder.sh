source $stdenv/setup

buildPhase=buildPhase
buildPhase() {
    xmkmf
    make World
	sed -e 's@/usr/bin/perl@'$perl'/bin/perl@' -i vncserver

	cd Xvnc
	sed -e 's@.* CppCmd .*@#define CppCmd		'$gcc'/bin/cpp@' -i config/cf/linux.cf 
	sed -e 's@.* CppCmd .*@#define CppCmd		'$gcc'/bin/cpp@' -i config/cf/Imake.tmpl 
        sed -i \
               -e 's@"uname","xauth","Xvnc","vncpasswd"@"uname","Xvnc","vncpasswd"@g' \
               -e "s@\<xauth\>@$xauth/bin/xauth@g" \
               ../vncserver
	./configure
	make
	cd ..
}

installPhase=installPhase
installPhase() {
    ensureDir $out/bin
    ensureDir $out/man/man1
    ./vncinstall $out/bin $out/man
}

genericBuild
