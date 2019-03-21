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
    version = "2.5.14";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "0sd04h2k5qv4m48dn76jkjlwlqfdk15hzyagj9i71r8brvmwhnk9";
    };
  }));
}
