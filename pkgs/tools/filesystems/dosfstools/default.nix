{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, libiconv, gettext, xxd }:

stdenv.mkDerivation rec {
  pname = "dosfstools";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "dosfstools";
    repo = "dosfstools";
    rev = "v${version}";
    sha256 = "sha256-2gxB0lQixiHOHw8uTetHekaM57fvUd9zOzSxWnvUz/c=";
  };

  patches = [
    # macOS build fixes backported from master
    # TODO: remove on the next release
    (fetchpatch {
      url = "https://github.com/dosfstools/dosfstools/commit/77ffb87e8272760b3bb2dec8f722103b0effb801.patch";
      sha256 = "sha256-xHxIs3faHK/sK3vAVoG8JcTe4zAV+ZtkozWIIFBvPWI=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ]
    ++ lib.optional stdenv.isDarwin libiconv;

  # configure.ac:75: error: required file './config.rpath' not found
  # https://github.com/dosfstools/dosfstools/blob/master/autogen.sh
  postPatch = ''
    cp ${gettext}/share/gettext/config.rpath config.rpath
  '';

  configureFlags = [ "--enable-compat-symlinks" ];

  nativeCheckInputs = [ xxd ];
  doCheck = true;

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = "https://github.com/dosfstools/dosfstools";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3;
  };
}
