{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cbbih035h40hhl7ykmyh9q9nzdqq1p8hmvzd4358cigz1gjc3j2";
  };

  vendorSha256 = "0s7mhbjfpfmzqf48d7k0d416m39x6fh5ds4q3xnvhcfx5kmdymq6";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  meta = with stdenv.lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun filalex77 ];
  };
}
