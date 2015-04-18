{stdenv, fetchgit, cmake} :

stdenv.mkDerivation {
  name = "ddate-0.2.2";
  src = fetchgit {
    url = "https://github.com/bo0ts/ddate";
    rev = "refs/tags/v0.2.2";
    sha256 = "1mv7x8g6ddzspcxghzz5dsxrj0x7bw5hc9yvqbl9va9z7nahwv80";
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
