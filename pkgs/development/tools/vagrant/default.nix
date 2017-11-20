{ stdenv, fetchurl, fetchpatch, dpkg, curl, libarchive, openssl, rake, ruby, buildRubyGem, libiconv
, libxml2, libxslt, libffi, makeWrapper, p7zip, xar, gzip, cpio }:

let
  version = "2.0.1";

  url = if stdenv.isLinux
    then "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_${arch}.deb"
    else if stdenv.isDarwin
      then "https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_${arch}.dmg"
      else "system ${stdenv.system} not supported";

  sha256 = {
    "x86_64-linux"  = "0kyqchjsy747vbvhqiynz81kik8g0xqpkv70rz7hyr9x7fl9i51g";
    "i686-linux"    = "0p3xhxy6shkd0393wjyj8qycdn3zqv60vnyz1b6zclz0kfah07zs";
    "x86_64-darwin" = "01hr5j9k31hsdlcwv3srzk0lphd8w0n9z95jvfkschdyjm9clpwm";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  arch = builtins.replaceStrings ["-linux" "-darwin"] ["" ""] stdenv.system;

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

  '' + (stdenv.lib.optionalString (! stdenv.isDarwin) ''
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
    rm -rf opt/vagrant/embedded/lib/*
    for lib in ${ruby}/lib/*; do
      ln -s $lib opt/vagrant/embedded/lib/''${lib##*/}
    done

    # libffi
    ln -s ${libffi}/lib/libffi.so.6 opt/vagrant/embedded/lib/libffi.so.6

  '') + ''
    mkdir -p "$out"
    cp -r opt "$out"
    cp -r usr/bin "$out"
    wrapProgram "$out/bin/vagrant" --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libxml2 libxslt ]}" \
                                   --prefix LD_LIBRARY_PATH : "$out/opt/vagrant/embedded/lib"

    install -D "opt/vagrant/embedded/gems/gems/vagrant-$version/contrib/bash/completion.sh" \
      "$out/share/bash-completion/completions/vagrant"
  '';

  preFixup = ''
    # 'hide' the template file from shebang-patching
    chmod -x "$out/opt/vagrant/embedded/gems/gems/vagrant-$version/plugins/provisioners/salt/bootstrap-salt.sh"
  '';

  postFixup = ''
    chmod +x "$out/opt/vagrant/embedded/gems/gems/vagrant-$version/plugins/provisioners/salt/bootstrap-salt.sh"
  '' +
  (stdenv.lib.optionalString stdenv.isDarwin ''
    # undo the directory movement done in unpackPhase
    mv $out/opt/vagrant/embedded $out/
    rm -r $out/opt
  '');
}
