{ stdenv, fetchurl, python, librsync, gnupg, makeWrapper }:

stdenv.mkDerivation {
  name = "duplicity-0.6.06";

  src = fetchurl {
    url = http://code.launchpad.net/duplicity/0.6-series/0.6.06/+download/duplicity-0.6.06.tar.gz;
    sha256 = "1g284y24061krigs386x5s7vs7cnwhah7g1mfk9jfn3gzsidv70g";
  };

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/duplicity \
      --prefix PYTHONPATH : "$(toPythonPath $out)" \
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
