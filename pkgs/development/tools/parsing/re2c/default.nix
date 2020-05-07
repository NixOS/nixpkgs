{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

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

  meta = with stdenv.lib; {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = licenses.publicDomain;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
