{ stdenv, fetchurl, gettext, libsepol, libselinux, libsemanage }:

stdenv.mkDerivation rec {
  name = "policycoreutils-${version}";
  version = "2.7";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/policycoreutils-${version}.tar.gz";
    sha256 = "1x742c7lkw30namhkw87yg7z384qzqjz0pvmqs0lk19v6958l6qa";
  };

  postPatch = ''
    # Fix install references
    substituteInPlace po/Makefile \
       --replace /usr/bin/install install --replace /usr/share /share
    substituteInPlace newrole/Makefile --replace /usr/share /share
  '';

  nativeBuildInputs = [ gettext ];
  buildInputs = [ libsepol libselinux libsemanage ];

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
    makeFlagsArray+=("BASHCOMPLETIONDIR=$out/share/bash-completion/completions")
    makeFlagsArray+=("LOCALEDIR=$out/share/locale")
    makeFlagsArray+=("MAN5DIR=$out/share/man/man5")
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

  NIX_CFLAGS_COMPILE = [
    "-fstack-protector-all"
    "-Wno-error=implicit-fallthrough" "-Wno-error=alloc-size-larger-than=" # gcc7
  ];

  meta = with stdenv.lib; {
    description = "SELinux policy core utilities";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}

