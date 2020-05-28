{ stdenv, fetchurl, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "pkgconf";
  version = "1.7.0";

  nativeBuildInputs = [ removeReferencesTo ];

  outputs = [ "out" "lib" "dev" "man" "doc" ];

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://distfiles.dereferenced.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0sb1a2lgiqaninv5s3zq09ilrkpsamcl68dyhqyz7yi9vsgb0vhy";
  };

  # Debian has outputs like these too:
  # https://packages.debian.org/source/buster/pkgconf, so take it this
  # reference removing is safe.
  postFixup = ''
    remove-references-to \
      -t "${placeholder "dev"}" \
      "${placeholder "lib"}"/lib/* \
      "${placeholder "out"}"/bin/*
    remove-references-to \
      -t "${placeholder "out"}" \
      "${placeholder "lib"}"/lib/*
  ''
  # Move back share/aclocal. Yes, this normally goes in the dev output for good
  # reason, but in this case the dev output is for the `libpkgconf` library,
  # while the aclocal stuff is for the tool. The tool is already for use during
  # development, so there is no reason to have separate "dev-bin" and "dev-lib"
  # outputs or someting.
  + ''
    mv ${placeholder "dev"}/share ${placeholder "out"}
  '';

  meta = with stdenv.lib; {
    description = "Package compiler and linker metadata toolkit";
    homepage = "https://git.dereferenced.org/pkgconf/pkgconf";
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ zaninime ];
  };
}
