{ gnustep, lib, fetchFromGitHub, fetchpatch, makeWrapper, python2, lndir
, openssl_1_1, openldap, sope, libmemcached, curl }: with lib; gnustep.stdenv.mkDerivation rec {
  pname = "SOGo";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "inverse-inc";
    repo = pname;
    rev = "SOGo-${version}";
    sha256 = "1xxad23a8zy6w850x5nrrf54db0x73lc9drmc5kpfk870fk2lmr0";
  };

  nativeBuildInputs = [ gnustep.make makeWrapper python2 ];
  buildInputs = [ gnustep.base sope openssl_1_1 libmemcached (curl.override { openssl = openssl_1_1; }) ]
    ++ optional (openldap != null) openldap;

  patches = [
    # TODO: take a closer look at other patches in https://sources.debian.org/patches/sogo/ and https://github.com/Skrupellos/sogo-patches
    (fetchpatch {
      url = "https://sources.debian.org/data/main/s/sogo/4.3.0-1/debian/patches/0005-Remove-build-date.patch";
      sha256 = "0lrh3bkfj3r0brahfkyb0g7zx7r2jjd5cxzjl43nqla0fs09wsh8";
    })
  ];

  postPatch = ''
    # Exclude NIX_ variables
    sed -i 's/grep GNUSTEP_/grep ^GNUSTEP_/g' configure

    # Disable argument verification because $out is not a GNUStep prefix
    sed -i 's/^validateArgs$//g' configure

    # Patch exception-generating python scripts
    patchShebangs .

    # Move all GNUStep makefiles to a common directory
    mkdir -p makefiles
    cp -r {${gnustep.make},${sope}}/share/GNUstep/Makefiles/* makefiles

    # Modify the search path for GNUStep makefiles
    find . -type f -name GNUmakefile -exec sed -i "s:\\$.GNUSTEP_MAKEFILES.:$PWD/makefiles:g" {} +
  '';

  configureFlags = [ "--disable-debug" "--with-ssl=ssl" ];

  preFixup = ''
    # Create gnustep.conf
    mkdir -p $out/share/GNUstep
    cp ${gnustep.make}/etc/GNUstep/GNUstep.conf $out/share/GNUstep/
    sed -i "s:${gnustep.make}:$out:g" $out/share/GNUstep/GNUstep.conf

    # Link in GNUstep base
    ${lndir}/bin/lndir ${gnustep.base}/lib/GNUstep/ $out/lib/GNUstep/

    # Link in sope
    ${lndir}/bin/lndir ${sope}/ $out/

    # sbin fixup
    mkdir -p $out/bin
    mv $out/sbin/* $out/bin
    rmdir $out/sbin

    # Make sogo find its files
    for bin in $out/bin/*; do
      wrapProgram $bin --prefix LD_LIBRARY_PATH : $out/lib/sogo --prefix GNUSTEP_CONFIG_FILE : $out/share/GNUstep/GNUstep.conf
    done
  '';

  meta = {
    description = "SOGo is a very fast and scalable modern collaboration suite (groupware)";
    license = with licenses; [ gpl2 lgpl21 ];
    homepage = "https://sogo.nu/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 das_j ];
  };
}

