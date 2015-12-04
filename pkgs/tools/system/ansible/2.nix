{ windowsSupport ? true, stdenv, fetchurl, pythonPackages, python }:

pythonPackages.buildPythonPackage rec {
  version    = "v2.0.0_0.6.rc1";
  name       = "ansible-${version}";
  namePrefix = "";

  src = fetchurl {
    url    = "http://releases.ansible.com/ansible/ansible-2.0.0-0.6.rc1.tar.gz";
    sha256 = "0v7fqi7qg9lzvpsjlaw9rzas8n1cdsyp3y9jrqzjxs9nbknwcibd";
  };

  prePatch = ''
    sed -i "s,/usr/,$out," lib/ansible/constants.py
  '';

  doCheck = false;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;

  pythonPath = with pythonPackages; [
    paramiko jinja2 pyyaml httplib2 boto six
  ] ++ stdenv.lib.optional windowsSupport pywinrm;

  meta = with stdenv.lib; {
    homepage    = "http://www.ansible.com";
    description = "A simple automation tool";
    license     = licenses.gpl3;
    maintainers = [ maintainers.copumpkin ];
    platforms   = platforms.linux ++ [ "x86_64-darwin" ];
  };
}
