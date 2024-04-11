{ lib, stdenv, fetchurl, python3
, libselinux, libsemanage, libsepol, setools }:

# this is python3 only because setools only supports python3

with lib;

stdenv.mkDerivation rec {
  pname = "selinux-python";
  version = "3.3";

  inherit (libsepol) se_url;

  src = fetchurl {
    url = "${se_url}/${version}/selinux-python-${version}.tar.gz";
    sha256 = "1v244hpb45my303793xa4kcn7qnxjgxn4ja7rdn9k1q361hi1nca";
  };

  strictDeps = true;

  nativeBuildInputs = [ python3 python3.pkgs.wrapPython ];
  buildInputs = [ libsepol ];
  propagatedBuildInputs = [ libselinux libsemanage setools python3.pkgs.ipy ];

  postPatch = ''
    substituteInPlace sepolicy/Makefile --replace "echo --root" "echo --prefix"
    substituteInPlace sepolgen/src/share/Makefile --replace "/var/lib/sepolgen" \
                                                            "\$PREFIX/var/lib/sepolgen"
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "LOCALEDIR=$(out)/share/locale"
    "BASHCOMPLETIONDIR=$(out)/share/bash-completion/completions"
    "PYTHON=python"
    "PYTHONLIBDIR=$(out)/${python3.sitePackages}"
    "LIBSEPOLA=${lib.getLib libsepol}/lib/libsepol.a"
  ];


  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "SELinux policy core utilities written in Python";
    license = licenses.gpl2Plus;
    homepage = "https://selinuxproject.org";
    platforms = platforms.linux;
  };
}
