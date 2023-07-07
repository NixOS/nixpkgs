{ lib, buildGoModule, fetchFromGitHub, keybase }:

buildGoModule {
  pname = "kbfs";

  inherit (keybase) src version vendorSha256;

  modRoot = "go";
  subPackages = [ "kbfs/kbfsfuse" "kbfs/redirector" "kbfs/kbfsgit/git-remote-keybase" ];

  tags = [ "production" ];
  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://keybase.io/docs/kbfs";
    description = "The Keybase filesystem";
    maintainers = with maintainers; [ avaq rvolosatovs bennofs np shofius ];
    license = licenses.bsd3;
  };
}
