{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite }:


buildGoModule rec {
  pname = "yubikey-agent";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "07gix5wrakn4z846zhvl66lzwx58djrfnn6m8v7vc69l9jr3kihr";
  };

  vendorSha256 = "1gn0w557w7cb9xd03sla6r389ncd3ik5bqwnrwzyb2imfpqwz58a";

  buildInputs = [ pcsclite ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  excludedPackages = "test";

  # Permission Denied
  # postPatch = ''
  #   substituteInPlace ${stdenv.lib.getDev pcsclite}/include/PCSC/winscard.h \
  #     --replace "pcsclite.h" "PCSC/pcsclite.h"
  # '';

  meta = with lib; {
    description = "yubikey-agent is a seamless ssh-agent for YubiKeys.";
    license = licenses.bsd3;
    homepage = "https://github.com/FiloSottile/yubikey-agent";
    maintainers = with maintainers; [ rawkode ];
  };
}
