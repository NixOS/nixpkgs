a :
let
  fetchurl = a.fetchurl;
  fetchgit = a.fetchgit;

  version = a.lib.attrByPath ["version"] "0.19-20120328" a;
  buildInputs = with a; [
    zlib libuuid acl attr e2fsprogs
  ];
in

assert a.libuuid != null;

rec {
  srcDrv = fetchgit {
    url="git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git" ;
    rev="1957076ab4fefa47b6efed3da541bc974c83eed7";
    sha256="566d863c5500652e999d0d6b823365fb06f2f8f9523e65e69eaa3e993e9b26e1";
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
      sed -e 's/progs = \(.*\)\\/progs = \1btrfs-image \\/' -i Makefile
    fi
  '') ["minInit" "doUnpack"];

  name = "btrfs-progs-" + version;
  meta = {
    description = "BTRFS utilities";
    maintainers = [a.lib.maintainers.raskin];
  };
}
