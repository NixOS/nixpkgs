# Use the static tools for i686-linux.  They work on x86_64-linux
# machines as well.
(import ../i686) //

{
  bootstrapTools = {
    url = http://nixos.org/tarballs/stdenv-linux/x86_64/r13932/bootstrap-tools.cpio.bz2;
    sha256 = "135lx2945cxf43g9n39dxcamw6f6n8qp5iqbh4xma575rf2bx5js";
  };
} 