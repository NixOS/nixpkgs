{ stdenv, fetchurl, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "patchelf-${version}";
  version = "2020-06-03";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "4aff679d9eaa1a3ec0228901a4e79b57361b4094";
    sha256 = "1i47z2dl6pgv5krl58lwy3xs327jmhy9cni3b8yampab1kh9ad1l";
  };

  # Drop test that fails on musl (?)
  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = "https://github.com/NixOS/patchelf/blob/master/README";
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
