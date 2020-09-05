{ python3Packages, fetchurl }:

rec {
  ansible = ansible_2_8;

  ansible_2_9 = python3Packages.toPythonApplication python3Packages.ansible;

  ansible_2_8 = with python3Packages; toPythonApplication (python3Packages.ansible.overrideAttrs(old: rec {
    pname = "ansible";
    version = "2.8.14";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "19ga0c9qs2b216qjg5k2yknz8ksjn8qskicqspg2d4b8x2nr1294";
    };
  }));

  ansible_2_7 = with python3Packages; toPythonApplication (ansible.overrideAttrs(old: rec {
    pname = "ansible";
    version = "2.7.18";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "0sgshaaqyjq3i035yi5hivmrrwrq05hxrbjrv1w3hfzmvljn41d1";
    };
  }));

  ansible_2_6 = with python3Packages; toPythonApplication (ansible.overrideAttrs(old: rec {
    pname = "ansible";
    version = "2.6.20";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "02ra9q2mifyawn0719y78wrbqzik73aymlzwi90fq71jgyfvkkqn";
    };

    meta.knownVulnerabilities = [
      # https://access.redhat.com/support/policy/updates/ansible-engine
      "Ansible 2.6 is End-of-Life since 2019/11/06 and affected by multiple CVEs."
    ];
  }));
}
