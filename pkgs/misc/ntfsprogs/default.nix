args: with args;
args.stdenv.mkDerivation {
  name = "ntfsprogs-2.0.0";

  src = fetchurl {
    name = "ntfsprogs-2.0.0.tar.bz2";
    url = "http://garr.dl.sourceforge.net/sourceforge/linux-ntfs/ntfsprogs-2.0.0.tar.bz2";
    sha256 = "ad36e19706c7303b10aa0a9bf2c2dd0309b91cd0171f1c9eb361d94a85017432";
  };

  meta = {
      description = "ntfs utilities";
      homepage = http://sourceforge.net/projects/linux-ntfs;
      license = "GPL";
  };
}
