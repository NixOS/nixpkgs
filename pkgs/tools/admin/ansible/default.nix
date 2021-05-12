{ python3Packages, fetchurl, fetchFromGitHub }:

rec {
  ansible = ansible_2_10;

  ansible_2_10 = python3Packages.toPythonApplication python3Packages.ansible-base;

  # End of support 2021/10/02, End of life 2021/12/31
  ansible_2_9 = python3Packages.toPythonApplication python3Packages.ansible;

  ansible_2_8 = python3Packages.toPythonApplication (python3Packages.ansible.overridePythonAttrs (old: rec {
    pname = "ansible";
    version = "2.8.14";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "19ga0c9qs2b216qjg5k2yknz8ksjn8qskicqspg2d4b8x2nr1294";
    };
  }));
}
