{ stdenv
, fetchFromGitHub
, ninja, meson
, libzip, openssl, xxHash, zlib
}:

stdenv.mkDerivation {
  pname = "rizin";
  version = "unstable-2021-01-13";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "rizin";
    rev = "ca2471ae9596176c656f065ed74c480f13784e1b";
    sha256 = "0qigy1px0jy74c5ig73dc2fqjcy6vcy76i25dx9r3as6zfpkkaxj";
  };

  postPatch = let
    capstone = fetchFromGitHub {
      owner = "aquynh";
      repo = "capstone";
      # version from $sourceRoot/shlr/Makefile
      rev = "4.0.2";
      sha256 = "0y5g74yjyliciawpn16zhdwya7bd3d7b1cccpcccc2wg8vni1k2w";
    };
  in ''
    mkdir -p build/shlr
    cp -r ${capstone} capstone-${capstone.rev}
    chmod -R +w capstone-${capstone.rev}
    tar -czvf shlr/capstone-${capstone.rev}.tar.gz capstone-${capstone.rev}
  '';

  configureFlags = [
    "--with-syszip"
    "--with-sysxxhash"
    "--with-openssl"
  ];

  enableParallelBuilding = true;

  buildInputs = [ openssl zlib ];

  propagatedBuildInputs = [ libzip xxHash ];

  meta = {
    description = "unix-like reverse engineering framework and commandline tools";
    homepage = "https://rizin.re/";
    license = stdenv.lib.licenses.lgpl3Only;
    maintainers = with stdenv.lib.maintainers; [ pamplemousse ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
