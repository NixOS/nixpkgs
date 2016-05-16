{ stdenv, fetchurl, python, librsync, ncftp, gnupg, boto, makeWrapper
, lockfile, setuptools, paramiko, pycrypto, ecdsa
}:

let
  version = "0.7.06";
in
stdenv.mkDerivation {
  name = "duplicity-${version}";

  src = fetchurl {
    url = "http://code.launchpad.net/duplicity/0.7-series/${version}/+download/duplicity-${version}.tar.gz";
    sha256 = "133zdi1rbiacvzjys7q3vjm7x84kmr51bsgs037rjhw9vdg5jx80";
  };

  installPhase = ''
    python setup.py install --prefix=$out
    wrapProgram $out/bin/duplicity \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${pycrypto}):$(toPythonPath ${ecdsa}):$(toPythonPath ${paramiko}):$(toPythonPath ${boto}):$(toPythonPath ${lockfile})" \
      --prefix PATH : "${gnupg}/bin:${ncftp}/bin"
    wrapProgram $out/bin/rdiffdir \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${pycrypto}):$(toPythonPath ${ecdsa}):$(toPythonPath ${paramiko}):$(toPythonPath ${boto}):$(toPythonPath ${lockfile})"
  '';

  buildInputs = [ python librsync makeWrapper setuptools ];

  meta = {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = "http://www.nongnu.org/duplicity";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric peti];
    platforms = with stdenv.lib.platforms; linux;
  };
}
