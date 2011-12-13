a :
let
  fetchurl = a.fetchurl;
  fetchgit = a.fetchgit;

  version = a.lib.attrByPath ["version"] "0.19" a;
  buildInputs = with a; [
    zlib libuuid acl attr
  ];
in

assert a.libuuid != null;

rec {
  srcDrv = fetchgit {
    url="git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git" ;
    rev="fdb6c0402337d9607c7a39155088eaf033742752" ;
    sha256="de7f9e04401bd747a831c48d312106e188adb32f32b6d64078ae6d2aab45b1f8" ;
  };

  src = srcDrv + "/";

  inherit buildInputs;
  configureFlags = [];
  makeFlags = ["prefix=$out CFLAGS=-Os"];

  patches = [];
  phaseNames = ["fixMakefile" "doEnsureBtrfsImage" "doMakeInstall"];

  fixMakefile = a.fullDepEntry ''
    sed -e 's@^progs = @progs=@g' -i Makefile
  '' ["minInit" "doUnpack"];

  doEnsureBtrfsImage = a.fullDepEntry (''
    if ! grep 'progs = ' Makefile | grep btrfs-image; then
      sed -e 's/progs = .*/& btrfs-image/' -i Makefile
    fi
  '') ["minInit" "doUnpack"];

  name = "btrfs-progs-" + version;
  meta = {
    description = "BTRFS utilities";
    maintainers = [a.lib.maintainers.raskin];
  };
}
