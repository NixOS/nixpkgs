{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "04hkz70s5i7ndwyg39za3k83amvmi90rkjm8qp3w3a8fbmq4q4y6";
  };

  vendorSha256 = "1zwrf2pshb9r3yvp7mqali47163nqhvs9ghflczfpigqswd1m0p0";

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
