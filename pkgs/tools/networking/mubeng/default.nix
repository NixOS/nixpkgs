{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    sha256 = "03hm4wqlvsbi06g0ijrhvbk9i2ahmd1m8l80wbcijznhbdl5msl8";
  };

  vendorSha256 = "1qcxix6724ly0klsr8bw3nv6pxn0wixqiqcgqkcp6sia4dxbbg14";

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
