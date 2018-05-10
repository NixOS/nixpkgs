{ stdenv, fetchurl, python3
, libselinux, libsemanage, libsepol, setools }:

# this is python3 only because setools only supports python3

with stdenv.lib;
with python3.pkgs;

stdenv.mkDerivation rec {
  name = "selinux-python-${version}";
  version = "2.7";
  se_release = "20170804";
  se_url = "https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases";

  src = fetchurl {
    url = "${se_url}/${se_release}/selinux-python-${version}.tar.gz";
    sha256 = "1va0y4b7cah7rprh04b3ylmwqgnivpkw5z2zw68nrafdbsbcn5s2";
  };

  nativeBuildInputs = [ wrapPython ];
  buildInputs = [ libsepol python3 ];
  propagatedBuildInputs = [ libselinux libsemanage setools ipy ];

  postPatch = ''
    substituteInPlace sepolicy/Makefile --replace "echo --root" "echo --prefix"
  '';

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
    makeFlagsArray+=("LOCALEDIR=$out/share/locale")
    makeFlagsArray+=("LIBSEPOLA=${libsepol}/lib/libsepol.a")
    makeFlagsArray+=("BASHCOMPLETIONDIR=$out/share/bash-completion/completions")
    makeFlagsArray+=("PYTHON=${python3}/bin/python")
    makeFlagsArray+=("PYTHONLIBDIR=lib/${python3.libPrefix}/site-packages")
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "SELinux policy core utilities written in Python";
    license = licenses.gpl2;
    homepage = https://selinuxproject.org;
    platforms = platforms.linux;
  };
}

