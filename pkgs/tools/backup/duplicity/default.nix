{ stdenv, fetchurl, python, librsync, gnupg, boto, makeWrapper }:

stdenv.mkDerivation {
  name = "duplicity-0.6.14";

  src = fetchurl {
    url = http://code.launchpad.net/duplicity/0.6-series/0.6.14/+download/duplicity-0.6.14.tar.gz;
    sha256 = "1h0gxi7hdz22fvah9mcavimfgahf31pixy1mx2mivncl14b45wf7";
  };

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/duplicity \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto})" \
      --prefix PATH : "${gnupg}/bin"
    wrapProgram $out/bin/rdiffdir \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto})" \
  '';

  buildInputs = [ python librsync makeWrapper ];

  meta = {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = http://www.nongnu.org/duplicity;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
