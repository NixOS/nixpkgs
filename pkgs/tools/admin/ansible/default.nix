{ stdenv, fetchurl, python2
, windowsSupport ? false
}:

let
  generic = { version, sha256, py ? python2 }: py.pkgs.buildPythonPackage rec {
    pname = "ansible";
    inherit version;

    outputs = [ "out" "man" ];

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      inherit sha256;
    };

    prePatch = ''
      sed -i "s,/usr/,$out," lib/ansible/constants.py
    '';

    postInstall = ''
      wrapPythonProgramsIn "$out/bin" "$out $PYTHONPATH"

      for m in docs/man/man1/*; do
        install -vD $m -t $man/share/man/man1
      done
    '';

    doCheck = false;
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = false;

    propagatedBuildInputs = with py.pkgs; [
      pycrypto paramiko jinja2 pyyaml httplib2 boto six netaddr dnspython jmespath dopy
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
    version = "2.5.11";
    sha256  = "07rhgkl3a2ba59rqh9pyz1p661gc389shlwa2sw1m6wwifg4lm24";
  };

  ansible_2_6 = generic {
    version = "2.6.7";
    sha256  = "10pakw9k9wd3cy1qk3ah2253ph7c7h3qzpal4k0s5lschzgy2fh0";
  };

  ansible_2_7 = generic {
    version = "2.7.6";
    sha256  = "0f7b2ghm34ql8yv90wr0ngd6w7wyvnlcxpc3snkj86kcjsnmx1bd";
  };

  ansible2 = ansible_2_7;
  ansible  = ansible2;
}
