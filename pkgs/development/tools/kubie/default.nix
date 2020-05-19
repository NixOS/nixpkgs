{ stdenv, rustPlatform, fetchFromGitHub }:

with rustPlatform;

buildRustPackage rec {
  pname = "kubie";
  version = "0.9.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "0q1dxry10iaf7zx6vyr0da4ihqx7l8dlyhlqm8qqfz913h2wam8c";
  };

  cargoSha256 = "13zs2xz3s4732zxsimg7b22d9707ln4gpscznxi13cjkf5as9gbz";

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
