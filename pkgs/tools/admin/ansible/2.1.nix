{ stdenv
, fetchurl
, fetchFromGitHub
, pythonPackages
, windowsSupport ? false
}:

with pythonPackages;

let
  jinja = jinja2.overridePythonAttrs (old: rec {
    version = "2.8.1";
    name = "${old.pname}-${version}";
    src = fetchFromGitHub {
      owner = "pallets";
      repo = "jinja";
      rev = version;
      sha256 = "0m6g6fx6flxb6hrkw757mbx1gxyrmj50w27m2afdsvmvz0zpdi2a";
    };
  });
in buildPythonPackage rec {
  pname = "ansible";
  version = "2.1.4.0";
  name = "${pname}-${version}";


  src = fetchurl {
    url = "http://releases.ansible.com/ansible/${name}.tar.gz";
    sha256 = "05nc68900qrzqp88970j2lmyvclgrjki66xavcpzyzamaqrh7wg9";
  };

  prePatch = ''
    sed -i "s,/usr/,$out," lib/ansible/constants.py
  '';

  doCheck = false;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = false;

  propagatedBuildInputs = [
    pycrypto paramiko jinja pyyaml httplib2 boto six netaddr dnspython
  ] ++ stdenv.lib.optional windowsSupport pywinrm;

  meta = with stdenv.lib; {
    homepage = http://www.ansible.com;
    description = "A simple automation tool";
    license = with licenses; [ gpl3] ;
    maintainers = with maintainers; [
      jgeerds
      joamaki
    ];
    platforms = with platforms; linux ++ darwin;
  };
}
