{ gnustep, lib, fetchFromGitHub, makeWrapper, python2, lndir
, openssl_1_1, openldap, sope, libmemcached, curl }: with lib; gnustep.stdenv.mkDerivation rec {
  pname = "SOGo";
  version = "4.0.8";

  src = fetchFromGitHub {
    owner = "inverse-inc";
    repo = pname;
    rev = "SOGo-${version}";
    sha256 = "10d2kz4vffspr3wh35dvj65lr57sr1gk0hy6hdn2nsygh4agl9nj";
  };

  nativeBuildInputs = [ gnustep.make makeWrapper python2 ];
  buildInputs = [ gnustep.base sope openssl_1_1 libmemcached (curl.override { openssl = openssl_1_1; }) ]
    ++ optional (openldap != null) openldap;

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
    description = "Very fast and scalable modern collaboration suite (groupware)";
    license = with licenses; [ gpl2 lgpl21 ];
    homepage = "https://sogo.nu/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ das_j ];
  };
}

