{ lib, stdenv, fetchFromGitHub, autoreconfHook, perl, withDebug ? false
, withXTinyProxy ? true, withFilter ? true, withUpstream ? true
, withTransparent ? true, withReverse ? true, withManpageSupport ? true }:

with lib;
stdenv.mkDerivation rec {
  pname = "tinyproxy";
  version = "1.11.0";

  src = fetchFromGitHub {
    sha256 = "13fhkmmrwzl657dq04x2wagkpjwdrzhkl141qvzr7y7sli8j0w1n";
    rev = version;
    repo = "tinyproxy";
    owner = "tinyproxy";
  };

  nativeBuildInputs = [
    autoreconfHook
  ] ++ optionals withManpageSupport [ perl ];

  configureFlags =
    optionals    (withDebug)           [ "--enable-debug" ]             # Enable debugging support code and methods.
    ++ optionals (!withXTinyProxy)     [ "--disable-xtinyproxy" ]       # Compile in support for the XTinyproxy header, which is sent to any web server in your domain.
    ++ optionals (!withFilter)         [ "--disable-filter"]            # Allows Tinyproxy to filter out certain domains and URLs.
    ++ optionals (!withUpstream)       [ "--disable-upstream" ]         # Enable support for proxying connections through another proxy server.
    ++ optionals (!withTransparent)    [ "--disable-transparent" ]      # Allow Tinyproxy to be used as a transparent proxy daemon.
    ++ optionals (!withReverse)        [ "--disable-reverse" ]          # Enable reverse proxying.
    ++ optionals (!withManpageSupport) [ "--disable-manpage_support" ]; # Enable support for building manpages.

  meta = {
    homepage = "https://tinyproxy.github.io/";
    description = "A light-weight HTTP/HTTPS proxy daemon for POSIX operating systems";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = [ maintainers.carlosdagos ];
  };
}
