{stdenv, fetchFromGitHub, cmake} :

stdenv.mkDerivation rec {
  pname = "ddate";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "bo0ts";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1qchxnxvghbma6gp1g78wnjxsri0b72ha9axyk31cplssl7yn73f";
  };

  buildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/bo0ts/ddate";
    description = "Discordian version of the date program";
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
    platforms = stdenv.lib.platforms.all;
  };
}
