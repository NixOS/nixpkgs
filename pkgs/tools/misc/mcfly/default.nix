{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "0pmyw21zns4zn7pffji4yvbj63fx3g15cx81pk4bs6lzyz5zbdc2";
  };

  preInstall = ''
    mkdir -p $out/share/mcfly
    cp mcfly.bash $out/share/mcfly/
    chmod +x $out/share/mcfly/mcfly.bash
  '';

  cargoSha256 = "1bf65kagvhsi6lg8187ihi5j45hkq9d8v6j7rzmmfhngdzvcfr69";

  meta = with stdenv.lib; {
    homepage = https://github.com/cantino/mcfly;
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now.";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.melkor333 ];
  };
}
