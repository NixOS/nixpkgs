{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "dirstalk";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "stefanoj3";
    repo = pname;
    rev = version;
    hash = "sha256-gSMkTGzMDI+scG3FQ0u0liUDL4qOPPW2UWLlAQcmmaA=";
  };

  patches = [
    # update dependencies to fix darwin build - remove in next release
    (fetchpatch {
      url = "https://github.com/stefanoj3/dirstalk/commit/79aef14c5c048f3a3a8374f42c7a0d52fc9f7b50.patch";
      sha256 = "sha256-2rSrMowfYdKV69Yg2QBzam3WOwGrSHQB+3uVi1Z2oJ8=";
    })
  ];

  vendorHash = "sha256-XY4vIh5de0tp4KPXTpzTm7/2bDisTjCsojLzxVDf4Jw=";

  subPackages = "cmd/dirstalk";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/stefanoj3/dirstalk/pkg/cmd.Version=${version}"
  ];

  # Tests want to write to the root directory
  doCheck = false;

  meta = with lib; {
    description = "Tool to brute force paths on web servers";
    homepage = "https://github.com/stefanoj3/dirstalk";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
