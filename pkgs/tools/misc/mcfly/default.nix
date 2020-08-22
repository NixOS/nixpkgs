{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "155x745jakfcpr6kmp24cy8xwdhv81jdfjjhd149bnw5ilg0z037";
  };

  postInstall = ''
    substituteInPlace mcfly.bash --replace '$(which mcfly)' $out/bin/mcfly
    substituteInPlace mcfly.zsh  --replace '$(which mcfly)' $out/bin/mcfly
    substituteInPlace mcfly.fish --replace '(which mcfly)' $out/bin/mcfly
    install -Dm644 -t $out/share/mcfly mcfly.bash
    install -Dm644 -t $out/share/mcfly mcfly.zsh
    install -Dm644 -t $out/share/mcfly mcfly.fish
  '';

  cargoSha256 = "0y6sjbzg5qqqip9sc9ajyd5ra3n2wwvarj6nhpzjhh05kqz3qja4";

  meta = with stdenv.lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
