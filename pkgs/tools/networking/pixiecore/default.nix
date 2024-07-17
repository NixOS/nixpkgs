{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pixiecore";
  version = "2020-03-25";
  rev = "68743c67a60c18c06cd21fd75143e3e069ca3cfc";

  src = fetchFromGitHub {
    owner = "danderson";
    repo = "netboot";
    inherit rev;
    hash = "sha256-SoD871PaL5/oabKeHFE2TLTTj/CFS4dfggjMN3qlupE=";
  };

  vendorHash = "sha256-hytMhf7fz4XiRJH7MnGLmNH+iIzPDz9/rRJBPp2pwyI=";

  doCheck = false;

  subPackages = [ "cmd/pixiecore" ];

  meta = {
    description = "A tool to manage network booting of machines";
    homepage = "https://github.com/danderson/netboot/tree/master/pixiecore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bbigras ];
    mainProgram = "pixiecore";
  };
}
