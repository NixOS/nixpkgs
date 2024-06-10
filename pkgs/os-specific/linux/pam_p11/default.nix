{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libp11, pam, libintl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pam_p11";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "pam_p11";
    rev = "pam_p11-${version}";
    sha256 = "1caidy18rq5zk82d51x8vwidmkhwmanf3qm25x1yrdlbhxv6m7lk";
  };

  patches = [
    # fix with openssl 3.x
    # https://github.com/OpenSC/pam_p11/pull/22
    (fetchpatch {
      name = "OpenSC-pam_p11-pull-22.patch";
      url = "https://github.com/OpenSC/pam_p11/compare/cd4eba2e921e1c2f93cde71922a76af99376246c...debd4f7acfaf998cfe4002e0be5c35ad9a9591b5.patch";
      excludes = [ ".github/build.sh" ];
      hash = "sha256-bm/agnBgvrr8L8yoGK4gzBqOGgsNWf9NIgcNJG7proE=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ pam libp11.passthru.openssl libp11 ]
    ++ lib.optionals stdenv.isDarwin [ libintl ];

  meta = with lib; {
    homepage = "https://github.com/OpenSC/pam_p11";
    description = "Authentication with PKCS#11 modules";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sb0 ];
  };
}
