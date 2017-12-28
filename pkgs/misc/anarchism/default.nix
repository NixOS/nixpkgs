{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "anarchism-${version}";
  version = "15.0";
  src = fetchurl {
    url = https://0xacab.org/ju/afaq/repository/master/archive.tar.gz;
    sha256 = "b081885152628c67c0f6d9101be17095d84684bc9dd2c7d4e50f5744614883ef";
  };

  installPhase = ''
    mkdir -p $out/share/doc/anarchism/html
    mkdir $out/share/doc/anarchism/markdown
    mkdir -p $out/share/applications/
    cp -r html $out/share/doc/anarchism/
    cp -r markdown $out/share/doc/anarchism/
    echo \[Desktop Entry\] > $out/share/applications/anarchism.desktop
    echo 'Encoding=UTF-8' >> $out/share/applications/anarchism.desktop
    echo 'Name=An Anarchist FAQ' >> $out/share/applications/anarchism.desktop
    echo 'GenericName=Anarchism' >> $out/share/applications/anarchism.desktop
    echo 'Comment=Exhaustive exploration of Anarchist theory and practice' >> $out/share/applications/anarchism.desktop
    echo Exec=xdg-open file:///$out/share/doc/anarchism/html/index.html >> $out/share/applications/anarchism.desktop
    echo 'Terminal=false' >> $out/share/applications/anarchism.desktop
    echo 'Type=Application' >> $out/share/applications/anarchism.desktop
    echo 'Categories=Education;' >> $out/share/applications/anarchism.desktop
    echo 'StartupNotify=true' >> $out/share/applications/anarchism.desktop
  '';

  meta = with stdenv.lib; {
    description = "Exhaustive exploration of Anarchist theory and practice.";
    longDescription = ''
      The Anarchist FAQ is an excellent source of information regarding
      Anarchist (libertarian socialist) theory and practice. It covers all major
      topics, from the basics of Anarchism to very specific discussions of
      politics, social organization, and economics.
    '';
    homepage = http://www.anarchistfaq.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.oida ];
    platforms = platforms.linux;
  };
}
