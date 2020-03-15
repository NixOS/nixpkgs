{ python3Packages, fetchurl }:

rec {
  ansible = ansible_2_8;

  ansible_2_9 = python3Packages.toPythonApplication python3Packages.ansible;

  ansible_2_8 = with python3Packages; toPythonApplication (python3Packages.ansible.overrideAttrs(old: rec {
    pname = "ansible";
    version = "2.8.7";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "0iy90kqxs52nspfkhj1y7z4zf017jfm5qhdb01d8d4jd5g53k0l2";
    };
  }));

  ansible_2_7 = with python3Packages; toPythonApplication (ansible.overrideAttrs(old: rec {
    pname = "ansible";
    version = "2.7.15";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "1kjqr35c11njyi3f2rjab6821bhqcrdykv4285q76gwv0qynigwr";
    };
  }));

  ansible_2_6 = with python3Packages; toPythonApplication (ansible.overrideAttrs(old: rec {
    pname = "ansible";
    version = "2.6.20";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "02ra9q2mifyawn0719y78wrbqzik73aymlzwi90fq71jgyfvkkqn";
    };
  }));
}
