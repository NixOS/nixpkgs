{
  lib,
  buildGoModule,
  keybase,
}:

buildGoModule {
  pname = "kbfs";

  inherit (keybase) src version vendorHash;

  modRoot = "go";
  subPackages = [
    "kbfs/kbfsfuse"
    "kbfs/redirector"
    "kbfs/kbfsgit/git-remote-keybase"
  ];

  tags = [ "production" ];
  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://keybase.io/docs/kbfs";
    description = "Keybase filesystem";
    maintainers = with maintainers; [
      avaq
      rvolosatovs
      bennofs
      np
      shofius
    ];
    license = licenses.bsd3;
  };
}
