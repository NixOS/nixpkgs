source $stdenv/setup

patchPhase() {
  fontPath=
  for i in $fontDirectories; do
    for j in $(find $i -name fonts.dir); do
      addToSearchPathWithCustomDelimiter "," fontPath $(dirname $j)
    done
  done
}

buildPhase() {

  xmkmf
  make World

	sed -e 's@/usr/bin/perl@'$perl'/bin/perl@' \
    -e 's@unix/:7100@'$fontPath'@' \
    -i vncserver

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

installPhase() {
    ensureDir $out/bin
    ensureDir $out/man/man1
    ./vncinstall $out/bin $out/man

    # fix HTTP client:
    t=$out/share/tightvnc
    ensureDir $t
    sed -i "s@/usr/local/vnc/classes@$out/vnc/classes@g" $out/bin/vncserver
    cp -r classes $t
}

genericBuild
