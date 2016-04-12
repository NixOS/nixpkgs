{ stdenv, fetchurl, fetchpatch, bash, curl, xsel }:

stdenv.mkDerivation {
  name = "imgurbash-4";

  src = fetchurl {
    url = "https://imgur.com/tools/imgurbash.sh";
    sha256 = "16m7dn5vqzx1q4pzssnwiwajfzrbhrz0niyhf5abxi1lwr3h0ca1";
  };

  patch = fetchpatch {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/001-api-v3.patch?h=imgurbash&id=c99b707cd0c373bfef659eb753efa897b0802b71";
    name = "001-api-v3.patch";
    sha256 = "1m5igwnpfmrvjaw1awcvjgszx25mzmcaqxs74s2gfafih52jrvxq";
  };

  buildCommand = ''
    mkdir -p $out/bin
    cat <<EOF >$out/bin/imgurbash
    #!${bash}/bin/bash
    PATH=${stdenv.lib.makeSearchPath "bin" [curl xsel]}:\$PATH
    EOF
    cat $src >>$out/bin/imgurbash
    patch $out/bin/imgurbash $patch
    chmod +x $out/bin/imgurbash
  '';

  meta = with stdenv.lib; {
    description = "A simple bash script to upload an image to imgur from the commandline";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
