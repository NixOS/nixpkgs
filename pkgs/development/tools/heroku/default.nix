{ stdenv, fetchFromGitHub, mkYarnPackage }:

mkYarnPackage rec {
  name = "heroku-${version}";
  version = "7.5.7";

  src = fetchFromGitHub {
    owner = "heroku";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1dnljah456z02d8nsyksg9w9pg35b8vk7q9zqygp84qbghz5pkdc";
  };

  meta = with stdenv.lib; {
    homepage = https://toolbelt.heroku.com;
    description = "Everything you need to get started using Heroku";
    maintainers = with maintainers; [ aflatter mirdhyn peterhoeg ];
    license = licenses.mit;
    platforms = with platforms; unix;
    hydraPlatforms = []; # https://github.com/NixOS/nixpkgs/issues/20637
  };
}
