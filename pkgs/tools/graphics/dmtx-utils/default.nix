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
  version = "0.7.6-unstable-2023-09-21";

  src = fetchFromGitHub {
    owner = "dmtx";
    repo = "dmtx-utils";
    rev = "057faa00143c152e8e21c29a36137f771614daed";
    hash = "sha256-uXzPAv6DappyHBNmsTg6qRUvtUUdP1IPOdDvIcevfco=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libdmtx imagemagick ]
    ++ lib.optional stdenv.hostPlatform.isDarwin Foundation;

  meta = {
    description = "Data matrix command-line utilities";
    homepage = "https://github.com/dmtx/dmtx-utils";
    changelog = "https://github.com/dmtx/dmtx-utils/blob/v${version}/ChangeLog";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
  };
}
