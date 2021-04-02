{ python3Packages, fetchurl, fetchFromGitHub }:

rec {
  ansible = ansible_2_10;

  # The python module stays at v2.9.x until the related package set has caught up. Therefore v2.10 gets an override
  # for now.
  ansible_2_10 = python3Packages.toPythonApplication (python3Packages.ansible.overridePythonAttrs (old: rec {
    pname = "ansible";
    version = "2.10.7";

    # TODO: migrate to fetchurl, when release becomes available on releases.ansible.com
    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-qDUc3mvsGmZHA2TCfKFJgGcB6e1pxlBP5Oc5QJjLzLA=";
    };
  }));

  ansible_2_9 = python3Packages.toPythonApplication python3Packages.ansible_2_9;

  ansible_2_8 = python3Packages.toPythonApplication (python3Packages.ansible_2_9.overridePythonAttrs (old: rec {
    pname = "ansible";
    version = "2.8.19";

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
      sha256 = "sha256-3HXu4MIFl/rWVp0Q6KsNm6XmTzvkQDsGsWJ++rZjUgM=";
    };
  }));
}
