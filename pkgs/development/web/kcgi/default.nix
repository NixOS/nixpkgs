{ stdenv, pkgconfig, fetchFromGitHub, libbsd }:

stdenv.mkDerivation rec {
  pname = "kcgi";
  version = "0.10.7";
  underscoreVersion = stdenv.lib.replaceChars ["."] ["_"] version;
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "1z8gfj1v69hhkiyybr41qw7yv3cdxahgk45nipxfb9nmn18p0k8n";
  };
  patchPhase = ''substituteInPlace configure \
    --replace /usr/local /
  '';
  
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ] ++ stdenv.lib.optionals stdenv.isLinux [ libbsd ] ;

  dontAddPrefix = true;

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://kristaps.bsd.lv/kcgi;
    description = "Minimal CGI and FastCGI library for C/C++";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = [ maintainers.leenaars ];
  };
}
