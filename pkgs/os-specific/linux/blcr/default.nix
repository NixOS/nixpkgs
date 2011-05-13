{ stdenv, fetchurl, kernel, perl, makeWrapper, autoconf, automake, libtool }:

assert stdenv.isLinux;

let
  version = "0.8.2";
  #website = https://ftg.lbl.gov/CheckpointRestart;
in

stdenv.mkDerivation {
  name = "blcr-${version}-${kernel.version}";

  src = fetchurl {
    url = https://ftg.lbl.gov/assets/projects/CheckpointRestart/downloads/blcr-0.8.2.tar.gz;
    #url = "${website}/downloads/blcr-${version}.tar.gz";
    sha256 = "1ldvzrajljkm318z5ix1p27n0gmv7gqxij6ck7p5fz4ncdbb01x8";
  };
  
  patchFlags = "-p0";

  patches = map fetchurl [
    { url = http://upc-bugs.lbl.gov/blcr-dist/blcr-0.8.2+kernel-2.6.31.patch01;
      sha256 = "0jnz18kbrm64hahvhk35zakcpylad1khsp5kjxkj19j0lkjv3m4h";
    }
    { url = http://upc-bugs.lbl.gov/blcr-dist/blcr-0.8.2+kernel-2.6.32.patch02;
      sha256 = "1f5s9c7iiaxd67ki3bmz09mf66shzbl97hvwaq4nmk6miq94k1fw";
    }
    { url = http://upc-bugs.lbl.gov/blcr-dist/blcr-0.8.2+kernel-2.6.34.patch03;
      sha256 = "0g2v67n40ikx5hja7zgnc2axif16r2sibi5vf0r4wjzc5z9gdfrh";
    }
  ];

  buildInputs = [ perl makeWrapper autoconf automake libtool ];

  preConfigure = ''
    ./autogen.sh
    configureFlagsArray=(
      --with-linux=$(ls -d ${kernel}/lib/modules/*/build)
      --with-kmod-dir=$out/lib/modules/$(cd ${kernel}/lib/modules; ls -d 2.6.*)
      --with-system-map=${kernel}/System.map
    )
  '';

  postInstall = ''
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog" --prefix LD_LIBRARY_PATH ":" "$out/lib"
    done
  '';
      
  meta = {
    description = "Berkeley Lab Checkpoint/Restart for Linux (BLCR)";
    homepage = https://ftg.lbl.gov/projects/CheckpointRestart/;
    license = "GPL2";
  };
}
