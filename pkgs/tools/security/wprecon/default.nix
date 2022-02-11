{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wprecon";
  version = "1.6.3a";

  src = fetchFromGitHub {
    owner = "blackbinn";
    repo = pname;
    rev = version;
    sha256 = "0gqi4799ha3mf8r7ini0wj4ilkfsh80vnnxijfv9a343r6z5w0dn";
  };

  vendorSha256 = "1sab58shspll96rqy1rp659s0yikqdcx59z9b88d6p4w8a98ns87";

  meta = with lib; {
    description = "WordPress vulnerability recognition tool";
    homepage = "https://github.com/blackbinn/wprecon";
    # License Zero Noncommercial Public License 2.0.1
    # https://github.com/blackbinn/wprecon/blob/master/LICENSE
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ fab ];
    broken = true; # build fails, missing tag
  };
}
