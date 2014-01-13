{ stdenv, fetchurl, python, librsync, ncftp, gnupg, boto, makeWrapper }:

let
  version = "0.6.22";
in
stdenv.mkDerivation {
  name = "duplicity-${version}";

  src = fetchurl {
    url = "http://code.launchpad.net/duplicity/0.6-series/${version}/+download/duplicity-${version}.tar.gz";
    sha256 = "04jskh1j85s35vfzm9gylpl7ysn5njbl0gcg92bhc7v88l29nj3g";
  };

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/duplicity \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto})" \
      --prefix PATH : "${gnupg}/bin:${ncftp}/bin"
    wrapProgram $out/bin/rdiffdir \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${boto})" \
  '';

  buildInputs = [ python librsync makeWrapper ];

  meta = {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = "http://www.nongnu.org/duplicity";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric simons];
    platforms = with stdenv.lib.platforms; linux;
  };
}
