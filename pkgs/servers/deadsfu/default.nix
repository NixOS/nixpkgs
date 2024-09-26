{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "deadsfu";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "x186k";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-LvKQCrFxzP+sM4sEqMKduvvDr/5GjWFRNvcljj9WbZA=";
  };

  vendorSha256 = "sha256-aItx31AcLP8cmim1UQO6Gmm14YIT4mZQBM3Qmo9Y8zE=";
  # Seems broken in upstream.
  doCheck = false;

  meta = with lib; {
    description = "Dead-simple WebRTC broadcasting. From the browser, or your application. Cloud-native and scalable. ";
    homepage = "https://deadsfu.com/";
    maintainers = with maintainers; [ q3k ];
    license = licenses.mit;
  };
}
