{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "08zwrnpiihlir83fryani8pr972lmj1sjvhjc5pzlw1hks88i9m2";
  };

  goPackagePath = "github.com/Dreamacro/clash";
  modSha256 = "05i8mzhxzkgcmaa4gazfl8pq3n8mc4prww0ghl6m28cy7a0vsh7f";

  buildFlagsArray = [
    "-ldflags="
    "-X ${goPackagePath}/constant.Version=${version}"
  ];

  meta = with stdenv.lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun filalex77 ];
    platforms = platforms.all;
  };
}
