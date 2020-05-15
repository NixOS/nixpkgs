{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "sha256-VF6GZxWZbrJNixE3wItF4CtVpj9NuKjdotNXrYujugs=";
  };

  cargoSha256 = "sha256-b8xXaWACDJ143i8UV3DJDjqu8HiXdO4fe6YDR/GcHoU=";

  meta = with stdenv.lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.all;
  };
}
