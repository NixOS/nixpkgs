{ python3Packages, fetchurl }:

rec {
  ansible = ansible_2_9;

  ansible_2_9 = python3Packages.toPythonApplication python3Packages.ansible;

  ansible_2_8 = python3Packages.toPythonApplication (python3Packages.ansible.overridePythonAttrs (old: rec {
    pname = "ansible";
    version = "2.8.14";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "19ga0c9qs2b216qjg5k2yknz8ksjn8qskicqspg2d4b8x2nr1294";
    };
  }));

  ansible_2_7 = python3Packages.toPythonApplication (python3Packages.ansible.overridePythonAttrs (old: rec {
    pname = "ansible";
    version = "2.7.18";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "0sgshaaqyjq3i035yi5hivmrrwrq05hxrbjrv1w3hfzmvljn41d1";
    };
  }));
}
