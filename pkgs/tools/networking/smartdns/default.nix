{ stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "smartdns";
  version =
    "30"; # This would be used later in the next release as the FHS commit integrated into realse 31.

  src = fetchFromGitHub {
    owner = "pymumu";
    repo = pname;
    rev = "3ad7cd7f454eec2fbdf338c0eb0541da301f1e73";
    sha256 = "1y9p8gxpj2k4a10maggkxg8l55jvr7x1wyxi69waxf56ggh2dvv0";
  };

  buildInputs = [ openssl ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSTEMDSYSTEMUNITDIR=${placeholder "out"}/lib/systemd/system"
    "RUNSTATEDIR=/run"
  ];

  installFlags = [ "SYSCONFDIR=${placeholder "out"}/etc" ];

  meta = with stdenv.lib; {
    description =
      "A local DNS server to obtain the fastest website IP for the best Internet experience";
    longDescription = ''
      SmartDNS is a local DNS server. SmartDNS accepts DNS query requests from local clients, obtains DNS query results from multiple upstream DNS servers, and returns the fastest access results to clients.
      Avoiding DNS pollution and improving network access speed, supports high-performance ad filtering.
      Unlike dnsmasq's all-servers, smartdns returns the fastest access resolution.
    '';
    homepage = "https://github.com/pymumu/smartdns";
    maintainers = [ maintainers.lexuge ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
