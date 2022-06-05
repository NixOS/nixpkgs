{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ssb";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dkd02l30461cwn5hsssnjyb9s8ww179wll3l7z5hy1hv3x6h9g1";
  };

  vendorSha256 = "1q3dxizyz9bcdfs5j2bzhl2aadhd00cvzhj202wlls0zrlb9pp4f";

  meta = with lib; {
    description = "Tool to bruteforce SSH server";
    homepage = "https://github.com/kitabisa/ssb";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
