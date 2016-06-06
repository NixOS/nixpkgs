{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "gotty-${version}";
  version = "0.0.10";
  rev = "v${version}";

  goPackagePath = "github.com/yudai/gotty";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/yudai/gotty";
    sha256 = "1jc620j4y2r8706r6qn7g2nghiidaaj7f8m2vjgq2gwv288qjafd";
  };

  goDeps = ./deps.json;

  meta = with stdenv.lib; {
    description = "Share your terminal as a web application";
    homepage = "https://github.com/yudai/gotty";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.mit;
  };
}
