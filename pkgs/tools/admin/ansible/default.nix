{ python3Packages, fetchurl }:

{
  ansible = with python3Packages; toPythonApplication ansible;

  ansible_2_7 = with python3Packages; toPythonApplication ansible;

  ansible_2_6 = with python3Packages; toPythonApplication (ansible.overridePythonAttrs(old: rec {
    pname = "ansible";
    version = "2.6.9";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "12mysvdavkypgmyms1wjq2974lk97w893k23i6khigxrjj6r85z1";
    };
  }));

  ansible_2_5 = with python3Packages; toPythonApplication (ansible.overridePythonAttrs(old: rec {
    pname = "ansible";
    version = "2.5.15";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "1w9wfv1s2jq6vkx1hm6n69zwxv2pgjj7nidyg452miwh684jpg7z";
    };
  }));
}
