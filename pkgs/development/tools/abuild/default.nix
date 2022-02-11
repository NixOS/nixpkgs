{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, openssl
, zlib
, busybox
}:

stdenv.mkDerivation rec {
  pname = "abuild";
  version = "3.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.alpinelinux.org";
    owner = "alpine";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xsik9hyzzq861bi922sb5r8c6r4wpnpxz5kd30i9f20vvfpp5jx";
  };

  buildInputs = [
    openssl
    zlib
    busybox
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  patchPhase = ''
    substituteInPlace ./Makefile \
      --replace 'chmod 4555' '#chmod 4555'
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CFLAGS=-Wno-error"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    description = "Alpine Linux build tools";
    homepage = "https://gitlab.alpinelinux.org/alpine/abuild";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.unix;
  };

}
