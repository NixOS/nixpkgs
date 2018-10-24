{ stdenv, fetchurl, python2Packages, librsync, ncftp, gnupg, rsync, makeWrapper }:

python2Packages.buildPythonApplication rec {
  name = "duplicity-${version}";
  version = "0.7.18.1";

  src = fetchurl {
    url = "http://code.launchpad.net/duplicity/${stdenv.lib.versions.majorMinor version}-series/${version}/+download/${name}.tar.gz";
    sha256 = "17c0203y5qz9w8iyhs26l44qf6a1vp26b5ykz1ypdr2kv6g02df9";
  };

  buildInputs = [ librsync makeWrapper python2Packages.wrapPython ];
  propagatedBuildInputs = with python2Packages; [
    boto cffi cryptography ecdsa enum idna pygobject3 fasteners
    ipaddress lockfile paramiko pyasn1 pycrypto six
  ];
  checkInputs = with python2Packages; [ lockfile mock pexpect ];

  # lots of tests are failing, although we get a little further now with the bits in preCheck
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/duplicity \
      --prefix PATH : "${stdenv.lib.makeBinPath [ gnupg ncftp rsync ]}"

    wrapPythonPrograms
  '';

  preCheck = ''
    patchShebangs testing

    substituteInPlace testing/__init__.py \
      --replace 'mkdir testfiles' 'mkdir -p testfiles'
  '';

  meta = with stdenv.lib; {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = http://www.nongnu.org/duplicity;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms = platforms.unix;
  };
}
