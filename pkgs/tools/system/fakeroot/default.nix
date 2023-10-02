{ lib
, stdenv
, fetchurl
, fetchpatch
, getopt
, libcap
, gnused
, nixosTests
}:

stdenv.mkDerivation rec {
  version = "1.32.1";
  pname = "fakeroot";

  src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/f/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "1rll7qc4mby1h4b0sh8crgj0q5zmhl8wdxqjc5dwri5gbgvb0wn0";
  };

  patches = lib.optionals stdenv.isLinux [
    ./einval.patch

    # patches needed for musl libc, borrowed from alpine packaging.
    # it is applied regardless of the environment to prevent patchrot
    (fetchpatch {
      name = "do-not-redefine-id_t.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/fakeroot/do-not-redefine-id_t.patch?id=f68c541324ad07cc5b7f5228501b5f2ce4b36158";
      sha256 = "sha256-i9PoWriSrQ7kLZzbvZT3Kq1oXzK9mTyBqq808BGepOw=";
    })
    (fetchpatch {
      name = "fakeroot-no64.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/fakeroot/fakeroot-no64.patch?id=f68c541324ad07cc5b7f5228501b5f2ce4b36158";
      sha256 = "sha256-NCDaB4nK71gvz8iQxlfaQTazsG0SBUQ/RAnN+FqwKkY=";
    })
  ];

  buildInputs = [ getopt gnused ]
    ++ lib.optional (!stdenv.isDarwin) libcap
    ;

  postUnpack = ''
    sed -i -e "s@getopt@$(type -p getopt)@g" -e "s@sed@$(type -p sed)@g" ${pname}-${version}/scripts/fakeroot.in
  '';

  passthru = {
    tests = {
      # A lightweight *unit* test that exercises fakeroot and fakechroot together:
      nixos-etc = nixosTests.etc.test-etc-fakeroot;
    };
  };

  meta = {
    homepage = "https://salsa.debian.org/clint/fakeroot";
    description = "Give a fake root environment through LD_PRELOAD";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = lib.platforms.unix;
  };
}
