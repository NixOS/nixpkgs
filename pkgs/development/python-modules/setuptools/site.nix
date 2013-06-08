# Propagated by buildPythonPackge to process pth files

{ stdenv, python, setuptools }:

stdenv.mkDerivation {
  name = "python-setuptools-site-${setuptools.version}";

  buildInputs = [ python setuptools ];

  unpackPhase = "true";
  installPhase = ''
    dst="$out/lib/${python.libPrefix}/site-packages"
    ensureDir $dst
    ln -s ${setuptools}/lib/${python.libPrefix}/site-packages/site.* $dst/
  '';
}
