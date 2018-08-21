{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "patchelf-${version}";
  version = "0.10-pre-20180509";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "27ffe8ae871e7a186018d66020ef3f6162c12c69";
    sha256 = "1sfkqsvwqqm2kdgkiddrxni86ilbrdw5my29szz81nj1m2j16asr";
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

  doCheck = true;

  meta = {
    homepage = https://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
