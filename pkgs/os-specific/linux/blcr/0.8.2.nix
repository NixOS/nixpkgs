{stdenv, fetchurl, kernel, perl, makeWrapper}:

assert stdenv.isLinux;

let
  version = "0.8.2";
  website = https://ftg.lbl.gov/CheckpointRestart;
in

stdenv.mkDerivation {
  name = "blcr-${version}-${kernel.version}";

  src = fetchurl {
    url = "${website}/downloads/blcr-${version}.tar.gz";
    sha256 = "1ldvzrajljkm318z5ix1p27n0gmv7gqxij6ck7p5fz4ncdbb01x8";
  };

  patches = [ ./fixes.patch ];

  buildInputs = [ perl makeWrapper ];

  # this gives "configure: error: unrecognized option: `-d'"
  /*
  configureFlags = [
    "--with-linux=$(ls -d ${kernel}/lib/modules/ * /build)"
    "--with-kmod-dir=$out/lib/modules/$(cd ${kernel}/lib/modules; ls -d 2.6.*)" 
    "--with-system-map=${kernel}/System.map"
  ];
  */

  configurePhase = ''
    ./configure --prefix=$out \
    --with-linux=$(ls -d ${kernel}/lib/modules/*/build) \
    --with-kmod-dir=$out/lib/modules/$(cd ${kernel}/lib/modules; ls -d 2.6.*) \
    --with-system-map=${kernel}/System.map
  '';

  postInstall = ''
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog" --prefix LD_LIBRARY_PATH ":" "$out/lib"
    done
  '';
      
  meta = {
    description = "Berkeley Lab Checkpoint/Restart for Linux (BLCR)";
    homepage = website;
    license = "GPL2";
  };
}
