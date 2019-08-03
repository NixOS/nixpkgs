{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "pass-update-${version}";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-update";
    rev = "v${version}";
    sha256 = "0a81q0jfni185zmbislzbcv0qr1rdp0cgr9wf9riygis2xv6rs6k";
  };

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Pass extension that provides an easy flow for updating passwords";
    homepage = https://github.com/roddhjav/pass-update;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 the-kenny fpletz tadfisher ];
    platforms = platforms.unix;
  };
}
