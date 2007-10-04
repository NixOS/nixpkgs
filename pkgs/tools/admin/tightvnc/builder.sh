source $stdenv/setup

buildPhase=buildPhase
buildPhase() {
    xmkmf
    make World

	cd Xvnc
	sed -e 's@.* CppCmd .*@#define CppCmd		'$gcc'/bin/cpp@' -i config/cf/linux.cf 
	sed -e 's@.* CppCmd .*@#define CppCmd		'$gcc'/bin/cpp@' -i config/cf/Imake.tmpl 
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
