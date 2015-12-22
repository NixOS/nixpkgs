{ stdenv, fetchurl, dpkg, curl, libarchive, openssl, ruby, buildRubyGem, libiconv
, libxml2, libxslt }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";

let
  version = "1.8.0";
  rake = buildRubyGem {
    inherit ruby;
    name = "rake-10.4.2";
    sha256 = "1rn03rqlf1iv6n87a78hkda2yqparhhaivfjpizblmxvlw2hk5r8";
  };

in
stdenv.mkDerivation rec {
  name = "vagrant-${version}";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url    = "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_x86_64.deb";
        sha256 = "0hvi6db5lphgzsykm1wn76jj4wwmm6lshvvd0qz7ipyyyhnd7sjp";
      }
    else
      fetchurl {
        url    = "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_i686.deb";
        sha256 = "1jvscbxqbhavw4q81y5718qbyj74b9lwfw3gb4c1f4jmgm08wxxk";
      };

  meta = with stdenv.lib; {
    description = "A tool for building complete development environments";
    homepage    = http://vagrantup.com;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 globin jgeerds ];
    platforms   = platforms.linux;
  };

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x ${src} .
  '';

  buildPhase = false;

  installPhase = ''
    sed -i "s|/opt|$out/opt|" usr/bin/vagrant

    # overwrite embedded binaries

    # curl: curl, curl-config
    rm opt/vagrant/embedded/bin/{curl,curl-config}
    ln -s ${curl}/bin/curl opt/vagrant/embedded/bin
    ln -s ${curl}/bin/curl-config opt/vagrant/embedded/bin

    # libarchive: bsdtar, bsdcpio
    rm opt/vagrant/embedded/bin/{bsdtar,bsdcpio}
    ln -s ${libarchive}/bin/bsdtar opt/vagrant/embedded/bin
    ln -s ${libarchive}/bin/bsdcpio opt/vagrant/embedded/bin

    # openssl: c_rehash, openssl
    rm opt/vagrant/embedded/bin/{c_rehash,openssl}
    ln -s ${openssl}/bin/c_rehash opt/vagrant/embedded/bin
    ln -s ${openssl}/bin/openssl opt/vagrant/embedded/bin

    # ruby: erb, gem, irb, rake, rdoc, ri, ruby
    rm opt/vagrant/embedded/bin/{erb,gem,irb,rake,rdoc,ri,ruby}
    ln -s ${ruby}/bin/erb opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/gem opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/irb opt/vagrant/embedded/bin
    ln -s ${rake}/bin/rake opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/rdoc opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/ri opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/ruby opt/vagrant/embedded/bin

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

  preFixup = ''
    # 'hide' the template file from shebang-patching
    chmod -x $out/opt/vagrant/embedded/gems/gems/bundler-1.10.6/lib/bundler/templates/Executable
    chmod -x $out/opt/vagrant/embedded/gems/gems/vagrant-${version}/plugins/provisioners/salt/bootstrap-salt.sh
  '';

  postFixup = ''
    chmod +x $out/opt/vagrant/embedded/gems/gems/bundler-1.10.6/lib/bundler/templates/Executable
    chmod +x $out/opt/vagrant/embedded/gems/gems/vagrant-${version}/plugins/provisioners/salt/bootstrap-salt.sh
  '';
}
