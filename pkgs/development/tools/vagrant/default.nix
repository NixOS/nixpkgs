{ stdenv, fetchurl, fetchpatch, dpkg, curl, libarchive, openssl, ruby, buildRubyGem, libiconv
, libxml2, libxslt, makeWrapper, p7zip, xar, gzip, cpio }:

let
  version = "1.8.7";
  rake = buildRubyGem {
    inherit ruby;
    gemName = "rake";
    version = "10.4.2";
    sha256 = "1rn03rqlf1iv6n87a78hkda2yqparhhaivfjpizblmxvlw2hk5r8";
  };

  url = if stdenv.isLinux
    then "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_${arch}.deb"
    else if stdenv.isDarwin
      then "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}.dmg"
      else "system ${stdenv.system} not supported";

  sha256 = {
    "x86_64-linux"  = "10c77b643b73dd3ad7a45a89d8ab95b58b79dc10e0cf6e760fe24abc436b2fdb";
    "i686-linux"    = "9d2a70f34ab65d8d2cb013917f221835432aa63cd4ef781c9fd1404cfcfe7898";
    "x86_64-darwin" = "14d68f599a620cf421838ed037f0a1c4467e1b67475deeff62330a21fda4937b";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  arch = builtins.replaceStrings ["-linux"] [""] stdenv.system;

in stdenv.mkDerivation rec {
  name = "vagrant-${version}";
  inherit version;

  src = fetchurl {
    inherit url sha256;
  };

  meta = with stdenv.lib; {
    description = "A tool for building complete development environments";
    homepage    = http://vagrantup.com;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 globin jgeerds kamilchm ];
    platforms   = with platforms; linux ++ darwin;
  };

  buildInputs = [ makeWrapper ]
    ++ stdenv.lib.optional stdenv.isDarwin [ p7zip xar gzip cpio ];

  unpackPhase = if stdenv.isLinux
    then ''
      ${dpkg}/bin/dpkg-deb -x "$src" .
    ''
    else ''
      7z x $src
      cd Vagrant/
      xar -xf Vagrant.pkg
      cd core.pkg/
      cat Payload | gzip -d - | cpio -id

      # move unpacked directories to match unpacked .deb from linux,
      # so installPhase can be shared
      mkdir -p opt/vagrant/ usr/
      mv embedded opt/vagrant/embedded
      mv bin usr/bin
    '';

  buildPhase = "";

  installPhase = ''
    sed -i "s|/opt|$out/opt|" usr/bin/vagrant

    # overwrite embedded binaries

    # curl: curl, curl-config
    rm opt/vagrant/embedded/bin/{curl,curl-config}
    ln -s ${curl.bin}/bin/curl opt/vagrant/embedded/bin
    ln -s ${curl.dev}/bin/curl-config opt/vagrant/embedded/bin

    # libarchive: bsdtar, bsdcpio
    rm opt/vagrant/embedded/lib/libarchive*
    ln -s ${libarchive}/lib/libarchive.so opt/vagrant/embedded/lib/libarchive.so
    rm opt/vagrant/embedded/bin/{bsdtar,bsdcpio}
    ln -s ${libarchive}/bin/bsdtar opt/vagrant/embedded/bin
    ln -s ${libarchive}/bin/bsdcpio opt/vagrant/embedded/bin

    # openssl: c_rehash, openssl
    rm opt/vagrant/embedded/bin/{c_rehash,openssl}
    ln -s ${openssl.bin}/bin/c_rehash opt/vagrant/embedded/bin
    ln -s ${openssl.bin}/bin/openssl opt/vagrant/embedded/bin

    # ruby: erb, gem, irb, rake, rdoc, ri, ruby
    rm opt/vagrant/embedded/bin/{erb,gem,irb,rake,rdoc,ri,ruby}
    ln -s ${ruby}/bin/erb opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/gem opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/irb opt/vagrant/embedded/bin
    ln -s ${rake}/bin/rake opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/rdoc opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/ri opt/vagrant/embedded/bin
    ln -s ${ruby}/bin/ruby opt/vagrant/embedded/bin

    # ruby libs
    rm -rf opt/vagrant/embedded/lib
    ln -s ${ruby}/lib opt/vagrant/embedded/lib

    # libiconv: iconv
    rm opt/vagrant/embedded/bin/iconv
    ln -s ${libiconv}/bin/iconv opt/vagrant/embedded/bin

    # libxml: xml2-config, xmlcatalog, xmllint
    rm opt/vagrant/embedded/bin/{xml2-config,xmlcatalog,xmllint}
    ln -s ${libxml2.dev}/bin/xml2-config opt/vagrant/embedded/bin
    ln -s ${libxml2.bin}/bin/xmlcatalog opt/vagrant/embedded/bin
    ln -s ${libxml2.bin}/bin/xmllint opt/vagrant/embedded/bin

    # libxslt: xslt-config, xsltproc
    rm opt/vagrant/embedded/bin/{xslt-config,xsltproc}
    ln -s ${libxslt.dev}/bin/xslt-config opt/vagrant/embedded/bin
    ln -s ${libxslt.bin}/bin/xsltproc opt/vagrant/embedded/bin

    mkdir -p "$out"
    cp -r opt "$out"
    cp -r usr/bin "$out"
    wrapProgram "$out/bin/vagrant" --prefix LD_LIBRARY_PATH : "$out/opt/vagrant/embedded/lib"
  '';

  preFixup = ''
    # 'hide' the template file from shebang-patching
    chmod -x "$out/opt/vagrant/embedded/gems/gems/bundler-1.12.5/lib/bundler/templates/Executable"
    chmod -x "$out/opt/vagrant/embedded/gems/gems/vagrant-$version/plugins/provisioners/salt/bootstrap-salt.sh"
  '';

  postFixup = ''
    chmod +x "$out/opt/vagrant/embedded/gems/gems/bundler-1.12.5/lib/bundler/templates/Executable"
    chmod +x "$out/opt/vagrant/embedded/gems/gems/vagrant-$version/plugins/provisioners/salt/bootstrap-salt.sh"
  '' +
  (stdenv.lib.optionalString stdenv.isDarwin ''
    # undo the directory movement done in unpackPhase
    mv $out/opt/vagrant/embedded $out/
    rm -r $out/opt
  '');
}
