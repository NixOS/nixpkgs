{ stdenv, buildGoModule, fetchFromGitHub, gnum4, pam, fscrypt-experimental }:

# Don't use this for anything important yet!

buildGoModule rec {
  pname = "fscrypt";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "v${version}";
    sha256 = "0h1ssw9x37hvks8rcnsjq4nsl6djmhx53iiwrw8fw4lf3nlmdzpx";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'TAG_VERSION := $(shell git describe --tags)' "" \
      --replace "/usr/local" "$out"
  '';

  modSha256 = "110b647q6ljsg5gwlciqv4cddxmk332nahcrpidrpsiqs2yjv1md";

  nativeBuildInputs = [ gnum4 ];
  buildInputs = [ pam ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
  '';

  preFixup = ''
    remove-references-to -t ${fscrypt-experimental.go} $out/lib/security/pam_fscrypt.so
  '';

  meta = with stdenv.lib; {
    description =
      "A high-level tool for the management of Linux filesystem encryption";
    longDescription = ''
      This tool manages metadata, key generation, key wrapping, PAM integration,
      and provides a uniform interface for creating and modifying encrypted
      directories.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/google/fscrypt/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
