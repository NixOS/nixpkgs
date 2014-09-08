{ stdenv, fetchurl, python, librsync, ncftp, gnupg, boto, makeWrapper
, lockfile, setuptools }:

let
  version = "0.6.24";
in
stdenv.mkDerivation {
  name = "duplicity-${version}";

  src = fetchurl {
    url = "http://code.launchpad.net/duplicity/0.6-series/${version}/+download/duplicity-${version}.tar.gz";
    sha256 = "0l14nrhbgkyjgvh339bbhnm6hrdwrjadphq1jmpi0mcgcdbdfh8x";
  };

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/duplicity \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto}):$(toPythonPath ${lockfile})" \
      --prefix PATH : "${gnupg}/bin:${ncftp}/bin"
    wrapProgram $out/bin/rdiffdir \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto}):$(toPythonPath ${lockfile})" \
  '';

  buildInputs = [ python librsync makeWrapper setuptools ];

  meta = {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = "http://www.nongnu.org/duplicity";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric simons];
    platforms = with stdenv.lib.platforms; linux;
  };
}
