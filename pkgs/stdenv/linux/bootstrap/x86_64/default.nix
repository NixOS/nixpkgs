# Use the static tools for i686-linux.  They work on x86_64-linux
# machines as well.
(import ../i686) //

{
  bootstrapTools = {
    url = http://nixos.org/tarballs/stdenv-linux/x86_64/r23302/bootstrap-tools.cpio.bz2;
    sha256 = "0w89kqhx47yl0jifp2vffp073pyrqha5f312kp971smi4h41drna";
  };
}
