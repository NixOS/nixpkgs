{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gomapenum";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "GoMapEnum";
    rev = "v${version}";
    sha256 = "sha256-AjHqD9r4ZU5NCqXEovvQuV4eeMLBy2jO/uqZQiCTyNI=";
  };

  vendorSha256 = "sha256-65NF814w1IUgSDuLLIqfbsf22va4AUC2E05ZgmuOHGY=";

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  meta = with lib; {
    description = "Tools for user enumeration and password bruteforce";
    homepage = "https://github.com/nodauf/GoMapEnum";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
