{ lib, stdenv, fetchFromGitHub, gzip, popt, autoreconfHook
, mailutils ? null
, aclSupport ? true, acl
}:

stdenv.mkDerivation rec {
  pname = "logrotate";
  version = "3.18.1";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = version;
    sha256 = "sha256-OJOV++rtN9ry+l0c0eanpu/Pwu8cOHfyEaDWp3FZjkw=";
  };

  patches = [
    # Fix CVE-2022-1348 by backporting two upstream commits
    # - 1f76a381e2caa0603ae3dbc51ed0f1aa0d6658b9 and
    # - addbd293242b0b78aa54f054e6c1d249451f137d
    # in a custom patch, as cherry-picking directly failed.
    ./fix-cve-2022-1348.diff
  ];

  # Logrotate wants to access the 'mail' program; to be done.
  configureFlags = [
    "--with-compress-command=${gzip}/bin/gzip"
    "--with-uncompress-command=${gzip}/bin/gunzip"
  ] ++ lib.optionals (mailutils != null) [
    "--with-default-mail-command=${mailutils}/bin/mail"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ popt ] ++ lib.optionals aclSupport [ acl ];

  meta = with lib; {
    homepage = "https://github.com/logrotate/logrotate";
    description = "Rotates and compresses system logs";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.all;
  };
}
