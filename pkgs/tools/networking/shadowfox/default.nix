{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "shadowfox";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "SrKomodo";
    repo = "shadowfox-updater";
    rev = "v${version}";
    sha256 = "0j8ljnx281a5nwd3zpw7b25ndsxc26b52glk2hqhm5fh08f9w0d8";
  };

  goPackagePath = "github.com/SrKomodo/shadowfox-updater";

  modSha256 = "0anxrff09r5aw3a11iph0gigmcbmpfczm8him6ly57ywfzc5c850";

  buildFlags = "--tags release";

  postInstall = ''
    # Contains compiler package only used by projects CI, and buildGoModule
    # installs all binaries by default. So we remove this again.
    rm $out/bin/compiler
  '';

  meta = with stdenv.lib; {
    description = ''
      This project aims at creating a universal dark theme for Firefox while
      adhering to the modern design principles set by Mozilla.
    '';
    homepage = "https://overdodactyl.github.io/ShadowFox/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ infinisil ];
  };
}
