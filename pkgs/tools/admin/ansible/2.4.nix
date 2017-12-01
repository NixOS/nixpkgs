{ stdenv
, fetchurl
, pythonPackages
, windowsSupport ? false
}:

pythonPackages.buildPythonPackage rec {
  pname = "ansible";
  version = "2.4.2.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://releases.ansible.com/ansible/${name}.tar.gz";
    sha256 = "0n3n9py4s3aykiii31xq8g4wmd6693jvby0424pjrg0bna01apri";
  };

  prePatch = ''
    sed -i "s,/usr/,$out," lib/ansible/constants.py
  '';

  doCheck = false;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = false;

  propagatedBuildInputs = with pythonPackages; [
    pycrypto paramiko jinja2 pyyaml httplib2 boto six netaddr dns
  ] ++ stdenv.lib.optional windowsSupport pywinrm;

  meta = with stdenv.lib; {
    homepage = http://www.ansible.com;
    description = "A simple automation tool";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [
      jgeerds
      joamaki
    ];
    platforms = with platforms; linux ++ darwin;
  };
}
