{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "bzip3";
  version = "1.1.3";

  outputs = [ "bin" "dev" "out" ];

  src = fetchFromGitHub {
    owner = "kspalaiologos";
    repo = "bzip3";
    rev = version;
    hash = "sha256-puGtaL76p4BzSiTPf3qFgXN4pz90CDU9dziGIszk3to=";
  };

  postPatch = ''
    echo -n "${version}" > .tarball-version
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--disable-arch-native"
  ] ++ lib.optionals stdenv.isDarwin [ "--disable-link-time-optimization" ];

  meta = {
    description = "A better and stronger spiritual successor to BZip2";
    homepage = "https://github.com/kspalaiologos/bzip3";
    changelog = "https://github.com/kspalaiologos/bzip3/blob/${src.rev}/NEWS";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
}
