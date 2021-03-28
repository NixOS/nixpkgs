{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "re2c";
  version = "1.3";

  src = fetchFromGitHub {
    owner  = "skvadrik";
    repo   = "re2c";
    rev    = version;
    sha256 = "0aqlf2h6i2m3dq11dkq89p4w4c9kp4x66s5rhp84gmpz5xqv1x5h";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-21232-part1.patch";
      url = "https://github.com/skvadrik/re2c/commit/fd634998f813340768c333cdad638498602856e5.patch";
      sha256 = "1blyg5lyhqd4ymisih65xl0g36ig71ijia4skkkd59rdvj78aiw6";
    })

    (fetchpatch {
      name = "CVE-2018-21232-part2.patch";
      url = "https://github.com/skvadrik/re2c/commit/7b5643476bd99c994c4f51b8143f942982d85521.patch";
      sha256 = "0rhmgqrinpk49r9x75ygrs14lz72aw5ad5kr6qp9bdyl8gs082qp";
    })

    (fetchpatch {
      name = "CVE-2018-21232-part3.patch";
      url = "https://github.com/skvadrik/re2c/commit/4d9c809355b574f2a58eac119f5e076c48e4d1e2.patch";
      sha256 = "0k86wg9icw1gkqpf7rq2w6xsq4caxw3rc0zfxf39liwa35027rai";
    })

    (fetchpatch {
      name = "CVE-2018-21232-part4.patch";
      url = "https://github.com/skvadrik/re2c/commit/89be91f3df00657261870adbc590209fdb2bc405.patch";
      sha256 = "1aygy9va7jwby93chlskwg7z90fn07x5hym0gziwlkx8k900p3a3";
    })

    (fetchpatch {
      name = "CVE-2020-11958.patch";
      url = "https://github.com/skvadrik/re2c/commit/c4603ba5ce229db83a2a4fb93e6d4b4e3ec3776a.patch";
      sha256 = "1d95ahxk92g7k87sda9gxgmr3blyfzwd2y7h9jxj8zkd74knd9zh";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;
  enableParallelBuilding = true;

  preCheck = ''
    patchShebangs run_tests.sh
  '';

  meta = with lib; {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = licenses.publicDomain;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
