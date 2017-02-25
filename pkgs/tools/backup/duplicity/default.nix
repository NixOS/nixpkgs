{ stdenv, fetchurl, python2Packages, librsync, ncftp, gnupg, rsync, makeWrapper
}:

let
  version = "0.7.07.1";
in python2Packages.buildPythonApplication {
  name = "duplicity-${version}";

  src = fetchurl {
    url = "http://code.launchpad.net/duplicity/0.7-series/${version}/+download/duplicity-${version}.tar.gz";
    sha256 = "594c6d0e723e56f8a7114d57811c613622d535cafdef4a3643a4d4c89c1904f8";
  };

  postInstall = ''
    wrapProgram $out/bin/duplicity \
      --prefix PATH : "${stdenv.lib.makeBinPath [ gnupg ncftp rsync ]}"
  '';

  buildInputs = [ librsync makeWrapper ];

  # Inputs for tests. These are added to buildInputs when doCheck = true
  checkInputs = with python2Packages; [ lockfile mock pexpect ];

  # Many problematic tests
  doCheck = false;

  propagatedBuildInputs = with python2Packages; [ boto cffi cryptography ecdsa enum idna
    ipaddress lockfile paramiko pyasn1 pycrypto six ];

  meta = {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = "http://www.nongnu.org/duplicity";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric peti];
    platforms = stdenv.lib.platforms.unix;
  };
}
