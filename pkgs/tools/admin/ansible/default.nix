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
    version = "2.6.17";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "0ixr3g1nb02xblqyk87bzag8sj8phy37m24xflabfl1k2zfh0313";
    };
  }));
}
