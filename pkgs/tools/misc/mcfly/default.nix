{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "1g3n7ll0yg7w7hb3jgp25mlnqwsdzv0608f41z7q5gmsskdm3v1j";
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
