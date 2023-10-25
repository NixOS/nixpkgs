{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dorkscout";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "R4yGM";
    repo = pname;
    rev = version;
    sha256 = "0h2m458jxdm3xg0h2vb8yq1jc28jqwinv1pdqypdsbvsz48s0hxz";
  };

  vendorSha256 = "05vn9hd5r8cy45b3ixjch17v38p08k8di8gclq0i9rkz9bvy1nph";

  meta = with lib; {
    description = "Tool to automate the work with Google dorks";
    homepage = "https://github.com/R4yGM/dorkscout";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
