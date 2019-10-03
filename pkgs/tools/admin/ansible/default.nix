{ python3Packages, fetchurl }:

{
  ansible = with python3Packages; toPythonApplication ansible;

  ansible_2_8 = with python3Packages; toPythonApplication ansible;

  ansible_2_7 = with python3Packages; toPythonApplication (ansible.overridePythonAttrs(old: rec {
    pname = "ansible";
    version = "2.7.13";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "1bmff1ynqgl15vya7hafji0g47gdv19986hw3v75b1cypyhqg71k";
    };
  }));

  ansible_2_6 = with python3Packages; toPythonApplication (ansible.overridePythonAttrs(old: rec {
    pname = "ansible";
    version = "2.6.19";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "01nafwmyk15xplfb2q3jpqr7r9j5h1ri7ixl8w8mxl10yvfwkkyv";
    };
  }));
}
