{ stdenv, fetchurl, pythonPackages, gettext
, setools, libsepol, libselinux, libcap_ng, libsemanage, sepolgen
}:

stdenv.mkDerivation rec {
  name = "policycoreutils-${version}";
  version = "2.4";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/policycoreutils-${version}.tar.gz";
    sha256 = "0y9l9k60iy21hj0lcvfdfxs1fxydg6d3pxp9rhy7hwr4y5vgh6dq";
  };

  patches = [ ./fix-printf-type.patch ];

  postPatch = ''
    # Fix references to libsepol.a
    find . -name Makefile -exec sed -i 's,[^ ]*/libsepol.a,${libsepol}/lib/libsepol.a,g' {} \;

    # Fix install references
    substituteInPlace po/Makefile --replace /usr/bin/install install

    # Fix references to /usr/share
    grep -r '/usr/share' | awk -F: '{print $1}' | xargs sed -i "s,\(\$(DESTDIR)\)*/usr/share,$out/share,g"

    # Fix sepolicy install
    sed -i "s,\(setup.py install\).*,\1 --prefix=$out,g" sepolicy/Makefile

    # Fix setuid install
    sed -i 's|-m 4755|-m 755|' sandbox/Makefile
  '';

  nativeBuildInputs = [ pythonPackages.python gettext ];
  buildInputs = [ setools libsepol libselinux libcap_ng libsemanage ];
  pythonPath = [ libselinux sepolgen ];

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
  '';

  # Creation of the system-config-selinux directory is broken
  preInstall = ''
    mkdir -p $out/share/system-config-selinux
  '';

  # Fix the python scripts to include paths to libraries
  # NOTE: We are not using wrapPythonPrograms or makeWrapper as these scripts
  # purge the environment as a security measure
  postInstall = ''
    grep -r '#!.*python' $out/bin | awk -F: '{print $1}' | xargs sed -i "1a \
    import sys; \
    sys.path.append('$(toPythonPath "$out")'); \
    ${stdenv.lib.flip stdenv.lib.concatMapStrings pythonPath (lib: ''
      sys.path.append('$(toPythonPath "${lib}")'); \
    '')}"
  '';

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";

  meta = with stdenv.lib; {
    description = "SELinux policy core utilities";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
