{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "patchelf";
  version = "0.10-pre-20190328";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "e1e39f3639e39360ceebb2f7ed533cede4623070";
    sha256 = "09q1b1yqfzg1ih51v7qjh55vxfdbd8x5anycl8sfz6qy107wr02k";
  };

  # Drop test that fails on musl (?)
  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '' +
  # extend version identifier to more informative than "0.10".
  ''
    echo -n ${version} > version
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = !stdenv.isDarwin;

  meta = {
    homepage = https://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
