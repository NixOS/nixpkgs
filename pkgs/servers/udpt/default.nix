{ stdenv, fetchFromGitHub, boost, sqlite }:

stdenv.mkDerivation rec {
  name = "udpt-${version}";
  version = "2016-02-20"; # v2.0-rc0 with sample config

  enableParallelBuilding = true;

  # Suitable for a network facing daemon.
  hardeningEnable = [ "pie" ];

  src = fetchFromGitHub {
    owner = "naim94a";
    repo = "udpt";
    rev = "0790558de8b5bb841bb10a9115bbf72c3b4711b5";
    sha256 = "0rgkjwvnqwbnqy7pm3dk176d3plb5lypaf12533yr0yfzcp6gnzk";
  };

  buildInputs = [ boost sqlite ];

  postPatch = ''
    # Enabling optimization (implied by fortify hardening) causes htons
    # to be re-defined as a macro, turning this use of :: into a syntax error.
    sed -i '104a#undef htons' src/udpTracker.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/etc/
    cp udpt $out/bin
    cp udpt.conf $out/etc/
    # without this, the resulting binary is unstripped.
    runHook postInstall
  '';

  meta = {
    description = "A lightweight UDP torrent tracker";
    homepage = https://naim94a.github.io/udpt;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
  };
}
