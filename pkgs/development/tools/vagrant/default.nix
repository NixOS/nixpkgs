{ stdenv, fetchurl, dpkg, curl, libarchive, openssl, ruby, rubyLibs, libiconv
, libxml2, libxslt }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";

stdenv.mkDerivation rec {
  name = "vagrant-1.3.5";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url    = http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/vagrant_1.3.5_x86_64.deb;
        sha256 = "0wfdz1r6i6acdrqb22n21iijz57ywjh4wd3fggcj65c0dvs0czfv";
      }
    else
      fetchurl {
        url    = http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/vagrant_1.3.5_i686.deb;
        sha256 = "0dq1ha278mjca1kdhijs6wzs61npvv1knvahnbiihxmhjsx5d9ih";
      };

  meta = with stdenv.lib; {
    description = "A tool for building complete development environments";
    homepage    = http://vagrantup.com;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x ${src} .
  '';

  buildPhase = false;

  installPhase = ''
    sed -i "s|/opt|$out/opt|" usr/bin/vagrant

    # overwrite embedded binaries

    # curl: curl
    rm opt/vagrant/embedded/bin/curl
    ln -s ${curl}/bin/curl opt/vagrant/embedded/bin

    # libarchive: bsdtar, bsdcpio
    rm opt/vagrant/embedded/bin/{bsdtar,bsdcpio}
    ln -s ${libarchive}/bin/bsdtar opt/vagrant/embedded/bin
    ln -s ${libarchive}/bin/bsdcpio opt/vagrant/embedded/bin

    # openssl: c_rehash, openssl
    rm opt/vagrant/embedded/bin/{c_rehash,openssl}
    ln -s ${openssl}/bin/c_rehash opt/vagrant/embedded/bin
    ln -s ${openssl}/bin/openssl opt/vagrant/embedded/bin

    # ruby: erb, gem, irb, rake, rdoc, ri, ruby, testrb
    rm opt/vagrant/embedded/bin/{erb,gem,irb,rake,rdoc,ri,ruby,testrb}
    ln -s ${ruby}/bin/erb opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/gem opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/irb opt/vagrant/embedded/bin
    ln -s ${rubyLibs.rake}/bin/rake opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/rdoc opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/ri opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/ruby opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/testrb opt/vagrant/embedded/bin

    # libiconv: iconv
    rm opt/vagrant/embedded/bin/iconv
    ln -s ${libiconv}/bin/iconv opt/vagrant/embedded/bin

    # libxml: xml2-config, xmlcatalog, xmllint
    rm opt/vagrant/embedded/bin/{xml2-config,xmlcatalog,xmllint}
    ln -s ${libxml2}/bin/xml2-config opt/vagrant/embedded/bin
    ln -s ${libxml2}/bin/xmlcatalog opt/vagrant/embedded/bin
    ln -s ${libxml2}/bin/xmllint opt/vagrant/embedded/bin

    # libxslt: xslt-config, xsltproc
    rm opt/vagrant/embedded/bin/{xslt-config,xsltproc}
    ln -s ${libxslt}/bin/xslt-config opt/vagrant/embedded/bin
    ln -s ${libxslt}/bin/xsltproc opt/vagrant/embedded/bin

    mkdir -p "$out"
    cp -r opt "$out"
    cp -r usr/bin "$out"
  '';
}
