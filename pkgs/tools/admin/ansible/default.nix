{ python3Packages, fetchurl }:

{
  ansible = with python3Packages; toPythonApplication ansible;

  ansible_2_7 = with python3Packages; toPythonApplication ansible;

  ansible_2_6 = with python3Packages; toPythonApplication (ansible.overridePythonAttrs(old: rec {
    pname = "ansible";
    version = "2.6.15";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "1l4ji9sryfn0l651hy6cf5zqq8fpwi956c7qzjm4sihz5ps6wyhd";
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
