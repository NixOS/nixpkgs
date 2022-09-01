{ lib, stdenv, fetchpatch, fetchFromGitHub, cmake, openssl, sqlite, pkg-config
, systemd, tlsSupport ? false }:

assert tlsSupport -> openssl != null;

stdenv.mkDerivation rec {
  pname = "uhub";
  version = "unstable-2019-12-13";

  src = fetchFromGitHub {
    owner = "janvidar";
    repo = "uhub";
    rev = "35d8088b447527f56609b85b444bd0b10cd67b5c";
    hash = "sha256-CdTTf82opnpjd7I9TTY+JDEZSfdGFPE0bq/xsafwm/w=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ sqlite systemd ] ++ lib.optional tlsSupport openssl;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/lib/uhub/" "$out/plugins" \
      --replace "/etc/uhub" "$TMPDIR"
  '';

  cmakeFlags = [
    "-DSYSTEMD_SUPPORT=ON"
    "-DSSL_SUPPORT=${lib.boolToCMakeString tlsSupport}"
  ];

  meta = with lib; {
    description = "High performance peer-to-peer hub for the ADC network";
    homepage = "https://www.uhub.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.unix;
  };
}
