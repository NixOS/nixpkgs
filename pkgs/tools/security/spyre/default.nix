{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, yara
}:

buildGoModule rec {
  pname = "spyre";
<<<<<<< HEAD
  version = "1.2.5";
=======
  version = "1.2.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "spyre-project";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wlGZTMCJE6Ki5/6R6J9EJP06/S125BNNd/jNPYGwKNw=";
  };

  patches = [
    # The following two patches come from https://github.com/spyre-project/spyre/pull/75
    # and improve Darwin support.
    (fetchpatch {
      name = "syscall-to-x-sys-unix.patch";
      url = "https://github.com/spyre-project/spyre/commit/8f08daf030c847de453613eb2eb1befdb7300921.patch";
      hash = "sha256-oy8Y85IubJVQrt0kmGA1hidZapgCw2aB6F/gT7uQ6KA=";
    })
    (fetchpatch {
      name = "darwin-skip-dir.patch";
      url = "https://github.com/spyre-project/spyre/commit/12dea550bc4f3275f8f406c19216ad140733a6af.patch";
      hash = "sha256-BXLGOshyGnllbkvsbbmdnqvRHwycrjI52oGWBoXXgL0=";
    })
  ];

  vendorHash = "sha256-aoeAnyFotKWWaRZQsgQPwwmhih/1zfL9eBV/2r1VPBM=";
=======
    sha256 = "sha256-408UOY7kvukMYOVqQfpugk6Z+LNQV9XyfJirKyBRWd4=";
  };

  vendorSha256 = "sha256-qZkt5WwicDXrExwMT0tCO+FZgClIHhrVtMR8xNsdAaQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    yara
  ];

  meta = with lib; {
    description = "YARA-based IOC scanner";
    homepage = "https://github.com/spyre-project/spyre";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
