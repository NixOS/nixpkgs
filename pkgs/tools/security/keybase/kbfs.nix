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

<<<<<<< HEAD
  meta = {
    homepage = "https://keybase.io/docs/kbfs";
    description = "Keybase filesystem";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://keybase.io/docs/kbfs";
    description = "Keybase filesystem";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      avaq
      rvolosatovs
      bennofs
      np
      shofius
    ];
<<<<<<< HEAD
    license = lib.licenses.bsd3;
=======
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
