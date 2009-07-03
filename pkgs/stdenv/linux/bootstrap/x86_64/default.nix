# Use the static tools for i686-linux.  They work on x86_64-linux
# machines as well.
(import ../i686) //

{
  bootstrapTools = {
    url = http://nixos.org/tarballs/stdenv-linux/x86_64/r16022/bootstrap-tools.cpio.bz2;
    sha256 = "1hwmyd9x9lhmb1ckwap2lvf7wi34p1j23v5bw41drym4mfp97ynz";
  };
}
