{ lib, stdenv, pkg-config, fetchFromGitHub, libbsd, bmake, zlib }:

stdenv.mkDerivation rec {
  pname = "kcgi";
  version = "0.13.0";
  underscoreVersion = lib.replaceStrings ["."] ["_"] version;

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = pname;
    rev = "VERSION_${underscoreVersion}";
    sha256 = "sha256-3/2oL5n4j/4Iwxam6SaPmThSoIY7c2l3EnYlnwjNifk=";
  };
  patchPhase = ''substituteInPlace configure \
    --replace /usr/local /
  '';

  nativeBuildInputs = [ pkg-config bmake ];
  buildInputs = [ zlib ] ++ lib.optionals stdenv.isLinux [ libbsd ] ;

  dontAddPrefix = true;

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://kristaps.bsd.lv/kcgi";
    description = "Minimal CGI and FastCGI library for C/C++";
    license = licenses.isc;
    changelog = "https://kristaps.bsd.lv/kcgi/archive.html";
    platforms = platforms.all;
    maintainers = [ maintainers.leenaars ];
    mainProgram = "kfcgi";
  };
}
