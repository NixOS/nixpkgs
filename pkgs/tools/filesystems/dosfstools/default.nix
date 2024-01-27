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
    # macOS and FreeBSD build fixes backported from master
    # TODO: remove on the next release
    (fetchpatch {
      url = "https://github.com/dosfstools/dosfstools/commit/77ffb87e8272760b3bb2dec8f722103b0effb801.patch";
      sha256 = "sha256-xHxIs3faHK/sK3vAVoG8JcTe4zAV+ZtkozWIIFBvPWI=";
    })
    (fetchpatch {
      url = "https://github.com/dosfstools/dosfstools/commit/2d3125c4a74895eae1f66b93287031d340324524.patch";
      sha256 = "nlIuRDsNjk23MKZL9cZ05odOfTXvsyQaKcv/xEr4c+U=";
    })
    # reproducible builds fix backported from master
    # (respect SOURCE_DATE_EPOCH)
    # TODO: remove on the next release
    (fetchpatch {
      url = "https://github.com/dosfstools/dosfstools/commit/8da7bc93315cb0c32ad868f17808468b81fa76ec.patch";
      sha256 = "sha256-Quegj5uYZgACgjSZef6cjrWQ64SToGQxbxyqCdl8C7o=";
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
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
  };
}
