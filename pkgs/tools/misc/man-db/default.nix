{ buildPackages
, db
, fetchurl
, fetchpatch
, groff
, gzip
, lib
, libiconv
, libpipeline
, makeWrapper
, nixosTests
, pkg-config
, stdenv
, zstd
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "man-db";
  version = "2.11.2";

  src = fetchurl {
    url = "mirror://savannah/man-db/man-db-${version}.tar.xz";
    hash = "sha256-z/oe5Ol0vnhkbEZQjm3S8358WJqqspOMwQZPBY/vn40=";
  };

  outputs = [ "out" "doc" ];
  outputMan = "out"; # users will want `man man` to work

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook groff makeWrapper pkg-config zstd ];
  buildInputs = [ libpipeline db groff ]; # (Yes, 'groff' is both native and build input)
  nativeCheckInputs = [ libiconv /* for 'iconv' binary */ ];

  patches = [
    ./systemwide-man-db-conf.patch
    # Remove the patches below when updating to the next man-db release.
    # Patches addressing https://gitlab.com/man-db/man-db/-/issues/25 ...
    (fetchpatch {
      name = "update-warning-regex";
      url = "https://gitlab.com/man-db/man-db/-/commit/b12ffb9df7.patch";
      hash = "sha256-F+whRppaMZwgmGPKTXu2j1vZMNAm3vGNzNZcz9pg8Jc=";
    })
    (fetchpatch {
      name = "fix-test-failures-when-iconv-not-available";
      url = "https://gitlab.com/man-db/man-db/-/commit/26f46a60e5.patch";
      hash = "sha256-W1a6GkYn4J3py7GLZc37xmQBQR18Xvcvj4fJoZ21+0k=";
      # The following files are excluded from the patch as they fail to apply
      # cleanly on the 2.11.2 sources and are deemed irrelevant for building man-db.
      excludes = [ "NEWS.md" ];
    })
    # ... and https://gitlab.com/man-db/man-db/-/issues/26.
    (fetchpatch {
      name = "improve-lexgrog-portability";
      url = "https://gitlab.com/man-db/man-db/-/commit/bbf7701c4f.patch";
      hash = "sha256-QLOVgV0S2NxxTBObD8bJFR1QDH0p2RGMJXLVNagfddc=";
    })
    (fetchpatch {
      name = "avoid-translation-fallout-from-lexgrog-fix";
      url = "https://gitlab.com/man-db/man-db/-/commit/043c3cb83c.patch";
      hash = "sha256-w12/LOGN9gO85zmqX7zookA55w3WUxBMJgWInpH5wms=";
    })
  ];

  postPatch = ''
    # Remove all mandatory manpaths. Nixpkgs makes no requirements on
    # these directories existing.
    sed -i 's/^MANDATORY_MANPATH/# &/' src/man_db.conf.in

    # Add Nix-related manpaths
    echo "MANPATH_MAP	/nix/var/nix/profiles/default/bin	/nix/var/nix/profiles/default/share/man" >> src/man_db.conf.in

    # Add mandb locations for the above
    echo "MANDB_MAP	/nix/var/nix/profiles/default/share/man	/var/cache/man/nixpkgs" >> src/man_db.conf.in
  '';

  configureFlags = [
    "--disable-setuid"
    "--disable-cache-owner"
    "--localstatedir=/var"
    "--with-config-file=${placeholder "out"}/etc/man_db.conf"
    "--with-systemdtmpfilesdir=${placeholder "out"}/lib/tmpfiles.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-pager=less"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "ac_cv_func__set_invalid_parameter_handler=no"
    "ac_cv_func_posix_fadvise=no"
    "ac_cv_func_mempcpy=no"
  ];

  preConfigure = ''
    configureFlagsArray+=("--with-sections=1 n l 8 3 0 2 5 4 9 6 7")
  '';

  postInstall = ''
    # apropos/whatis uses program name to decide whether to act like apropos or whatis
    # (multi-call binary). `apropos` is actually just a symlink to whatis. So we need to
    # make sure that we don't wrap symlinks (since that changes argv[0] to the -wrapped name)
    find "$out/bin" -type f | while read file; do
      wrapProgram "$file" \
        --prefix PATH : "${lib.makeBinPath [ groff gzip zstd ]}"
    done
  '';

  disallowedReferences = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    buildPackages.groff
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isMusl /* iconv binary */;

  passthru.tests = {
    nixos = nixosTests.man;
  };

  meta = with lib; {
    homepage = "http://man-db.nongnu.org";
    description = "An implementation of the standard Unix documentation system accessed using the man command";
    license = licenses.gpl2;
    platforms = lib.platforms.unix;
    mainProgram = "man";
  };
}
