{ lib, stdenv, fetchFromGitHub, gzip, popt, autoreconfHook
, aclSupport ? true, acl
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "logrotate";
  version = "3.20.1";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = version;
    sha256 = "sha256-IegYAV7Mrw9GKMQOE5Bk0J/2ljfHzPlIipyYm3LrUcU=";
  };

  # Logrotate wants to access the 'mail' program; to be done.
  configureFlags = [
    "--with-compress-command=${gzip}/bin/gzip"
    "--with-uncompress-command=${gzip}/bin/gunzip"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ popt ] ++ lib.optionals aclSupport [ acl ];

  passthru.tests = {
    nixos-logrotate = nixosTests.logrotate;
  };

  meta = with lib; {
    homepage = "https://github.com/logrotate/logrotate";
    description = "Rotates and compresses system logs";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.all;
  };
}
