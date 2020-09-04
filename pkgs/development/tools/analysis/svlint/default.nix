{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svlint";
    rev = "v${version}";
    sha256 = "0gn68achvhyxljvhw5rwraxjcgdwrl1bwbsn596ka15nrk4lwb34";
  };

  cargoSha256 = "0v94zsh4jhzjnqbkgwn8rjbs72i5cw2nmkwn7xhdbbwxh17a88x4";

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
