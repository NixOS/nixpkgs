{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "dnstake";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "pwnesia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-k6j7DIwK8YAKmEjn8JJO7XBcap9ui6cgUSJG7CeHAAM=";
  };

  patches = [
    # https://github.com/pwnesia/dnstake/pull/36
    (fetchpatch {
      name = "update-x-sys-fix-darwin.patch";
      url = "https://github.com/pwnesia/dnstake/commit/974efbbff4ce26d2f2646ca2ceb1316c131cefbe.patch";
      sha256 = "sha256-fLOGF8damdLROd8T0fH/FGSVX23dtc+yHhSvVCwVeuY=";
    })
  ];

  vendorSha256 = "sha256-lV6dUl+OMUQfhlgNL38k0Re1Mr3VP9b8SI3vTJ8CP18=";

  meta = with lib; {
    description = "Tool to check missing hosted DNS zones";
    homepage = "https://github.com/pwnesia/dnstake";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
