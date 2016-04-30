{ stdenv, fetchFromGitHub, cmake, pkgconfig, autoconf, automake, libtool, expat, python, sphinx, gobjectIntrospection, librepo, check, rpm, libsolv, pcre, curl, gtk_doc, zlib, xz, elfutils }:

stdenv.mkDerivation rec {
  rev  = "87e4cb247f5982fd48636691a955cc566d3110a3";
  name = "libhif-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "rpm-software-management";
    repo   = "libhif";
    sha256 = "1g8hrqjawzwcx1gjcnv9sxg5i8l13dab3rr3i641k5vi76vv8miq";
  };

  postPatch = ''
    for file in python/hawkey/CMakeLists.txt python/hawkey/tests/module/CMakeLists.txt; do
      substituteInPlace $file --replace ' ''${PYTHON_INSTALL_DIR}' " $out/${python.sitePackages}"
    done

    # Until https://github.com/rpm-software-management/libhif/issues/43 is implemented, let's not force users to have this path
    substituteInPlace libhif/hif-keyring.c \
      --replace '"/etc/pki/rpm-gpg"' 'getenv("LIBHIF_RPM_GPG_PATH_OVERRIDE") ? getenv("LIBHIF_RPM_GPG_PATH_OVERRIDE") : "/etc/pki/rpm-gpg"'
 '';

  buildInputs = [ cmake pkgconfig pcre expat python sphinx gobjectIntrospection gtk_doc librepo check rpm curl ];

  # ibhif/hif-packagedelta.h includes solv/pool.h
  propagatedBuildInputs = [ libsolv ];

  meta = {
    description = "A library that provides a high level package-manager. It uses librepo and hawkey under the hood.";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

