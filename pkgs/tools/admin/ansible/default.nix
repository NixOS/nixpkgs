{ python3Packages, fetchurl, fetchFromGitHub }:

rec {
  ansible = ansible_2_11;

  ansible_2_11 = python3Packages.toPythonApplication python3Packages.ansible-core;

  ansible_2_10 = python3Packages.toPythonApplication python3Packages.ansible-base;

  # End of support 2021/10/02, End of life 2021/12/31
  ansible_2_9 = python3Packages.toPythonApplication python3Packages.ansible;

  ansible_2_8 = throw "Ansible 2.8 went end of life on 2021/01/03 and has subsequently been dropped";
}
