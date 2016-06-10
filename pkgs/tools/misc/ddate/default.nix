{stdenv, fetchgit, cmake} :

stdenv.mkDerivation {
  name = "ddate-0.2.2";
  src = fetchgit {
    url = "https://github.com/bo0ts/ddate";
    rev = "refs/tags/v0.2.2";
    sha256 = "1qchxnxvghbma6gp1g78wnjxsri0b72ha9axyk31cplssl7yn73f";
  };

  buildInputs = [ cmake ];

  meta = {
    homepage = https://github.com/bo0ts/ddate;
    description = "Discordian version of the date program";
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with stdenv.lib.maintainers; [kovirobi];
    platforms = with stdenv.lib.platforms; linux;
  };
}
