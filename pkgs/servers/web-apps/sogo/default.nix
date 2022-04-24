{ gnustep, lib, fetchFromGitHub, fetchpatch, makeWrapper, python3, lndir
, openssl, openldap, sope, libmemcached, curl, libsodium, libytnef, libzip, pkg-config, nixosTests
, oathToolkit }:
gnustep.stdenv.mkDerivation rec {
  pname = "SOGo";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "inverse-inc";
    repo = pname;
    rev = "SOGo-${version}";
    sha256 = "1kyfn3qw299qsyivbrm487h68va99rrb3gmhpgjpwqd2xdg9aypk";
  };

  nativeBuildInputs = [ gnustep.make makeWrapper python3 ];
  buildInputs = [ gnustep.base sope openssl libmemcached curl libsodium libytnef libzip pkg-config openldap oathToolkit ];

  patches = [
    # TODO: take a closer look at other patches in https://sources.debian.org/patches/sogo/ and https://github.com/Skrupellos/sogo-patches
    (fetchpatch {
      url = "https://salsa.debian.org/debian/sogo/-/raw/120ac6390602c811908c7fcb212a79acbc7f7f28/debian/patches/0005-Remove-build-date.patch";
      sha256 = "151i8504kwdlcirgd0pbif7cxnb1q6jsp5j7dbh9p6zw2xgwkp25";
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

  configureFlags = [
    "--disable-debug"
    "--with-ssl=ssl"
    "--enable-mfa"
  ];

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

  passthru.tests.sogo = nixosTests.sogo;

  meta = with lib; {
    description = "A very fast and scalable modern collaboration suite (groupware)";
    license = with licenses; [ gpl2Only lgpl21Only ];
    homepage = "https://sogo.nu/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 das_j ];
  };
}

