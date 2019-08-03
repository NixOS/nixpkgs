{ python3Packages, fetchurl }:

{
  ansible = with python3Packages; toPythonApplication ansible;

  ansible_2_8 = with python3Packages; toPythonApplication ansible;

  ansible_2_7 = with python3Packages; toPythonApplication (ansible.overridePythonAttrs(old: rec {
    pname = "ansible";
    version = "2.7.11";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "0zipzm9al6k74h88b6zkddpcbxqs4cms7lidid6wn1vx3d3dxrp7";
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
