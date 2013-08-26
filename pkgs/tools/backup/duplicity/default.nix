{ stdenv, fetchurl, python, librsync, ncftp, gnupg, boto, makeWrapper }:

stdenv.mkDerivation {
  name = "duplicity-0.6.21";

  src = fetchurl {
    url = "http://code.launchpad.net/duplicity/0.6-series/0.6.21/+download/duplicity-0.6.21.tar.gz";
    sha256 = "01ppxzghnig7al9cwi8ap95y0d3j5n0vf3ag06iw3ysiq6k8lqm3";
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
