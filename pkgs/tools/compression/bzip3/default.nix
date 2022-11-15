{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "bzip3";
  version = "1.2.1";

  outputs = [ "bin" "dev" "out" ];

  src = fetchFromGitHub {
    owner = "kspalaiologos";
    repo = "bzip3";
    rev = version;
    hash = "sha256-RzlDubT+nczIlUcwnZ5PsO5s3Op7WLRuiMBRBasuEFI=";
  };

  postPatch = ''
    echo -n "${version}" > .tarball-version
    patchShebangs build-aux

    # build-aux/ax_subst_man_date.m4 calls git if the file exists
    rm .gitignore
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
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
