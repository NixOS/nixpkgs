{ stdenv, rustPlatform, fetchFromGitHub }:

with rustPlatform;

buildRustPackage rec {
  pname = "kubie";
  version = "0.8.4";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "1f82xlhhxbjadjw609kr1kdm4n69c9mqjia4b3k505wjh7cc55n0";
  };

  cargoSha256 = "0mish7wqwq5ynl98n6swdn5i6mg62aih5rfykbl3wx39b468n481";

  installPhase = ''
    mkdir -p $out/share/bash-completion/completions
    cp -v ${src}/completion/kubie.bash $out/share/bash-completion/completions/kubie
  '';

  meta = with stdenv.lib; {
    description =
      "Shell independent context and namespace switcher for kubectl";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
    platforms = platforms.all;
  };
}
