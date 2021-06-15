{ lib
, buildGoModule
, fetchFromGitHub
, e2tools
, makeWrapper
, mtools
}:

buildGoModule rec {
  pname = "fwanalyzer";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "cruise-automation";
    repo = pname;
    rev = version;
    sha256 = "1pj6s7lzw7490488a30pzvqy2riprfnhb4nzxm6sh2nsp51xalzv";
  };

  vendorSha256 = "1cjbqx75cspnkx7fgc665q920dsxnsdhqgyiawkvx0i8akczbflw";

  subPackages = [ "cmd/${pname}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/fwanalyzer" --prefix PATH : "${lib.makeBinPath [ e2tools mtools ]}"
  '';

  # The tests requires an additional setup (unpacking images, etc.)
  doCheck = false;

  meta = with lib; {
    description = "Tool to analyze filesystem images";
    homepage = "https://github.com/cruise-automation/fwanalyzer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
