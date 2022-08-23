{ lib, stdenv, pkg-config, fetchFromGitHub, libbsd }:

stdenv.mkDerivation rec {
  pname = "kcgi";
  version = "0.10.8";
  underscoreVersion = lib.replaceChars ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "0ha6r7bcgf6pcn5gbd2sl7835givhda1jql49c232f1iair1yqyp";
  };
  patchPhase = ''substituteInPlace configure \
    --replace /usr/local /
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ] ++ lib.optionals stdenv.isLinux [ libbsd ] ;

  dontAddPrefix = true;

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://kristaps.bsd.lv/kcgi";
    description = "Minimal CGI and FastCGI library for C/C++";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = [ maintainers.leenaars ];
    mainProgram = "kfcgi";
  };
}
