{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libdmtx
, imagemagick
, Foundation
}:

stdenv.mkDerivation rec {
  pname = "dmtx-utils";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "dmtx";
    repo = "dmtx-utils";
    rev = "v${version}";
    sha256 = "06m3qncqdlcnmw83n95yrx2alaq6bld320ax26z4ndnla41yk0p4";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libdmtx imagemagick ]
    ++ lib.optional stdenv.isDarwin Foundation;

  meta = {
    description = "Data matrix command-line utilities";
    homepage = "https://github.com/dmtx/dmtx-utils";
    changelog = "https://github.com/dmtx/dmtx-utils/blob/v${version}/ChangeLog";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
  };
}
