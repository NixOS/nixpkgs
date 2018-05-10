{ stdenv, fetchurl, fetchFromGitHub, python2
, windowsSupport ? false
}:

let
  oldJinja = python2.override {
    packageOverrides = self: super: {
      jinja2 = super.jinja2.overridePythonAttrs (oldAttrs: rec {
        version = "2.8.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "14aqmhkc9rw5w0v311jhixdm6ym8vsm29dhyxyrjfqxljwx1yd1m";
        };
        doCheck = false;
      });
    };
  };

  generic = { version, sha256, py ? python2 }: py.pkgs.buildPythonPackage rec {
    pname = "ansible";
    inherit version;

    src = fetchurl {
      url = "http://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      inherit sha256;
    };

    prePatch = ''
      sed -i "s,/usr/,$out," lib/ansible/constants.py
    '';

    doCheck = false;
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = false;

    propagatedBuildInputs = with py.pkgs; [
      pycrypto paramiko jinja2 pyyaml httplib2 boto six netaddr dnspython
    ] ++ stdenv.lib.optional windowsSupport pywinrm;

    meta = with stdenv.lib; {
      homepage = http://www.ansible.com;
      description = "A simple automation tool";
      license = with licenses; [ gpl3 ] ;
      maintainers = with maintainers; [ jgeerds joamaki ];
      platforms = with platforms; linux ++ darwin;
    };
  };

in rec {
  # We will carry all the supported versions

  ansible_2_4 = generic {
    version = "2.4.4.0";
    sha256  = "0n1k6h0h6av74nw8vq98fmh6q4pq6brpwmx45282vh3bkdmpa0ib";
  };

  ansible_2_5 = generic {
    version = "2.5.2";
    sha256  = "1r9sq30xz3jrvx6yqssj5wmkml1f75rx1amd7g89f3ryngrq6m59";
  };

  ansible2 = ansible_2_5;
  ansible  = ansible2;
}
