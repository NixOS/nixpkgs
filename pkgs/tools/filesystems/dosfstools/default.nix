{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libiconv, gettext, xxd }:

stdenv.mkDerivation rec {
  pname = "dosfstools";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "dosfstools";
    repo = "dosfstools";
    rev = "v${version}";
    sha256 = "sha256-2gxB0lQixiHOHw8uTetHekaM57fvUd9zOzSxWnvUz/c=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ]
    ++ lib.optional stdenv.isDarwin libiconv;

  # configure.ac:75: error: required file './config.rpath' not found
  # https://github.com/dosfstools/dosfstools/blob/master/autogen.sh
  postPatch = ''
    cp ${gettext}/share/gettext/config.rpath config.rpath
  '';

  configureFlags = [ "--enable-compat-symlinks" ];

  checkInputs = [ xxd ];
  doCheck = true;

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = "https://github.com/dosfstools/dosfstools";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3;
  };
}
