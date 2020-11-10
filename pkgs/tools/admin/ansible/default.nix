{ python3Packages, fetchurl, fetchFromGitHub }:

rec {
  ansible = ansible_2_10;

  # The python module stays at v2.9.x until the related package set has caught up. Therefore v2.10 gets an override
  # for now.
  ansible_2_10 = python3Packages.toPythonApplication (python3Packages.ansible.overridePythonAttrs (old: rec {
    pname = "ansible";
    version = "2.10.0";

    # TODO: migrate to fetchurl, when release becomes available on releases.ansible.com
    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      sha256 = "0k9rs5ajx0chaq0xr1cj4x7fr5n8kd4y856miss6k01iv2m7yx42";
    };
  }));

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
