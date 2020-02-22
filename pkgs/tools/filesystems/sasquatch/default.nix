{ fetchFromGitHub
, fetchurl
, lz4 ? null
, lz4Support ? false
, lzma
, lzo
, stdenv
, xz
, zlib
}:

assert lz4Support -> (lz4 != null);

let
  patch = fetchFromGitHub {
    owner = "devttys0";
    repo = "sasquatch";
    rev = "3e0cc40fc6dbe32bd3a5e6c553b3320d5d91ceed";
    sha256 = "19lhndjv7v9w6nmszry63zh5rqii9v7wvsbpc2n6q606hyz955g2";
  } + "/patches/patch0.txt";
in
stdenv.mkDerivation rec {
  pname = "sasquatch";
  version = "4.3";

  src = fetchurl {
    url = mirror://sourceforge/squashfs/squashfs4.3.tar.gz;
    sha256 = "1xpklm0y43nd9i6jw43y2xh5zvlmj9ar2rvknh0bh7kv8c95aq0d";
  };

  buildInputs = [ lzma lzo xz zlib ]
    ++ stdenv.lib.optional lz4Support lz4;

  patches = [ patch ];
  patchFlags = [ "-p0" ];

  postPatch = ''
    cd squashfs-tools
  '';

  installFlags = [ "INSTALL_DIR=\${out}/bin" ];

  makeFlags = [ "XZ_SUPPORT=1" ]
    ++ stdenv.lib.optional lz4Support "LZ4_SUPPORT=1";

  meta = with stdenv.lib; {
    homepage = "https://github.com/devttys0/sasquatch";
    description = "Set of patches to the standard unsquashfs utility (part of squashfs-tools) that attempts to add support for as many hacked-up vendor-specific SquashFS implementations as possible";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pamplemousse ];
    platforms = platforms.linux;
  };
}
