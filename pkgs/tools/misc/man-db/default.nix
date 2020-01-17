{ stdenv, fetchurl, pkgconfig, libpipeline, db, groff, libiconv, makeWrapper, buildPackages }:

stdenv.mkDerivation rec {
  name = "man-db-2.9.0";

  src = fetchurl {
    url = "mirror://savannah/man-db/${name}.tar.xz";
    sha256 = "0qg2sdn8mayya0ril484iz1r7hi46l68d2d80cr6lvc7x3csqjjx";
  };

  outputs = [ "out" "doc" ];
  outputMan = "out"; # users will want `man man` to work

  nativeBuildInputs = [ pkgconfig makeWrapper groff ];
  buildInputs = [ libpipeline db groff ]; # (Yes, 'groff' is both native and build input)
  checkInputs = [ libiconv /* for 'iconv' binary */ ];

  postPatch = ''
    # Remove all mandatory manpaths. Nixpkgs makes no requirements on
    # these directories existing.
    sed -i 's/^MANDATORY_MANPATH/# &/' src/man_db.conf.in

    # Add Nixpkgs and NixOS-related manpaths
    echo "MANPATH_MAP	/run/current-system/sw/bin		/run/current-system/sw/share/man" >> src/man_db.conf.in
    echo "MANPATH_MAP	/run/wrappers/bin			/run/current-system/sw/share/man" >> src/man_db.conf.in
    echo "MANPATH_MAP	/nix/var/nix/profiles/default/bin	/nix/var/nix/profiles/default/share/man" >> src/man_db.conf.in

    # Add mandb locations for the above
    echo "MANDB_MAP	/run/current-system/sw/share/man	/var/cache/man/nixos" >> src/man_db.conf.in
    echo "MANDB_MAP	/nix/var/nix/profiles/default/share/man	/var/cache/man/nixpkgs" >> src/man_db.conf.in
  '';

  configureFlags = [
    "--disable-setuid"
    "--disable-cache-owner"
    "--localstatedir=/var"
    # Don't try /etc/man_db.conf by default, so we avoid error messages.
    "--with-config-file=${placeholder "out"}/etc/man_db.conf"
    "--with-systemdtmpfilesdir=${placeholder "out"}/lib/tmpfiles.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-pager=less"
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin [
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
      wrapProgram "$file" --prefix PATH : "${groff}/bin"
    done
  '';

  postFixup = stdenv.lib.optionalString (buildPackages.groff != groff) ''
    # Check to make sure none of the outputs depend on build-time-only groff:
    for outName in $outputs; do
      out=''${!outName}
      echo "Checking $outName(=$out) for references to build-time groff..."
      if grep -r '${buildPackages.groff}' $out; then
        echo "Found an erroneous dependency on groff ^^^" >&2
        exit 1
      fi
    done
  '';

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isMusl /* iconv binary */ && !stdenv.hostPlatform.isDarwin;

  meta = with stdenv.lib; {
    homepage = http://man-db.nongnu.org;
    description = "An implementation of the standard Unix documentation system accessed using the man command";
    license = licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
