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
      for m in docs/man/man1/*; do
        install -vD $m -t $man/share/man/man1
      done
    '';

    doCheck = false;
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = false;

    propagatedBuildInputs = with py.pkgs; [
      pycrypto paramiko jinja2 pyyaml httplib2 boto six netaddr dnspython jmespath
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

  ansible_2_6 = generic {
    version = "2.6.2";
    sha256  = "1y5gd9h641p6pphwd7j99yyqglyj23rkmid7wgzk62611754qzkl";
  };

  ansible2 = ansible_2_6;
  ansible  = ansible2;
}
