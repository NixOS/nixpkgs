{ python3Packages, fetchurl }:

{
  ansible = with python3Packages; toPythonApplication ansible;

  ansible_2_8 = with python3Packages; toPythonApplication ansible;

  ansible_2_7 = with python3Packages; toPythonApplication (ansible.overridePythonAttrs(old: rec {
    pname = "ansible";
    version = "2.7.15";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "1kjqr35c11njyi3f2rjab6821bhqcrdykv4285q76gwv0qynigwr";
    };
  }));

  ansible_2_6 = with python3Packages; toPythonApplication (ansible.overridePythonAttrs(old: rec {
    pname = "ansible";
    version = "2.6.20";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "02ra9q2mifyawn0719y78wrbqzik73aymlzwi90fq71jgyfvkkqn";
    };
  }));
}
