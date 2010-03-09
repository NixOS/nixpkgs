{ stdenv, fetchurl, python, librsync, gnupg, boto, makeWrapper }:

stdenv.mkDerivation {
  name = "duplicity-0.6.08";

  src = fetchurl {
    url = http://code.launchpad.net/duplicity/0.6-series/0.6.08/+download/duplicity-0.6.08.tar.gz;
    sha256 = "1qvaa61j8614wy2fv02f47dp58pry2j958gnd2c73flj2n0n1919";
  };

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/duplicity \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto})" \
      --prefix PATH : "${gnupg}/bin"
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
