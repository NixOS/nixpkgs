{stdenv, fetchFromGitHub, rpm}:

stdenv.mkDerivation rec {
  name = "epm-${version}";
  version = "4.4";

  src = fetchFromGitHub {
    repo = "epm";
    owner = "michaelrsweet";
    rev = "v${version}";
    sha256 = "0kaw7v2m20qirapkps4dna6nf9xibnwljvvv0l9vpvi920kw7j7p";
  };

  buildInputs = [ rpm ];

  preInstall = ''
    sed -i 's/README/README.md/' Makefile
  '';

  meta = with stdenv.lib; {
    description = "The ESP Package Manager generates distribution archives for a variety of platforms";
    homepage = https://www.msweet.org/projects.php?Z2;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
