{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "mcfly-${version}";
  version = "v0.3.1";
  rev = "${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "cantino";
    repo = "mcfly";
    sha256 = "0pmyw21zns4zn7pffji4yvbj63fx3g15cx81pk4bs6lzyz5zbdc2";
  };

  preInstall = ''
    mkdir -p $out/share/mcfly
    cp mcfly.bash $out/share/mcfly/
    chmod +x $out/share/mcfly/mcfly.bash
  '';

  cargoSha256 = "0asldrf6s23f9aylk9f8zimmaskgqv3vkdhfnrd26zl9axm0a0ap";

  meta = with stdenv.lib; {
    homepage = https://github.com/cantino/mcfly;
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now.";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.melkor333 ];
  };
}
