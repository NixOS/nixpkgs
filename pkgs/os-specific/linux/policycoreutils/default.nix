{ stdenv, fetchurl, gettext, libsepol, libselinux, libsemanage, audit, pam }:

stdenv.mkDerivation rec {
  name = "policycoreutils-${version}";
  version = "2.8";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/policycoreutils-${version}.tar.gz";
    sha256 = "168hph0y2paqn5hvc0ygw9lfxchylmgc7dy2sxxfwyzj6ni56rcq";
  };

  postPatch = ''
    # Fix install references
    substituteInPlace po/Makefile \
       --replace /usr/bin/install install --replace /usr/share /share
    substituteInPlace newrole/Makefile --replace /usr/share /share
  '';

  nativeBuildInputs = [ gettext ];
  buildInputs = [ libsepol libselinux libsemanage audit pam ];

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
    makeFlagsArray+=("BASHCOMPLETIONDIR=$out/share/bash-completion/completions")
    makeFlagsArray+=("LOCALEDIR=$out/share/locale")
    makeFlagsArray+=("MAN5DIR=$out/share/man/man5")
  '';

  meta = with stdenv.lib; {
    description = "SELinux policy core utilities";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
