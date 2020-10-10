{ python3Packages, fetchurl, fetchFromGitHub }:

rec {
  ansible = ansible_2_10;

  # The python module stays at v2.9.x until the related package set has caught up. Therefore v2.10 gets an override
  # for now.
  ansible_2_10 = python3Packages.toPythonApplication python3Packages.ansible-base;

  ansible_2_9 = python3Packages.toPythonApplication (python3Packages.ansible-base.overridePythonAttrs (old: rec {
    pname = "ansible";
    version = "2.9.14";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "1dbgzj5m6wx0jdjqbsz8n58jirlbjylfy94izngdvjgh10z1irzg";
    };
  }));

  ansible_2_8 = python3Packages.toPythonApplication (python3Packages.ansible-base.overridePythonAttrs (old: rec {
    pname = "ansible";
    version = "2.8.16";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "05mfrsncysjfxg4kbv5vllf3g58kzs01xafmviwqd16lq2jd68a2";
    };
  }));
}
