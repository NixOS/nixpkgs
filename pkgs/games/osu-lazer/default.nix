{ dotnet-sdk_3
, fetchFromGitHub
, fetchurl
, ffmpeg-full
, libGL
, icu
, Nuget
, openssl
, SDL2
, shared-mime-info
, stdenv }:

let
  deps = import ./deps.nix { inherit fetchurl; }; in
with stdenv;
mkDerivation rec {
  pname = "osu-lazer";
  version = "2020.306.0";

  src = fetchFromGitHub {
    owner = "ppy";
    repo = "osu";
    rev = "${version}";
    sha256 = "0m2ygyrl26xhzrd8l617k11rr8cbbh38i8jsphkfpcnqsmxk661w";
  };
  
  buildInputs = [ dotnet-sdk_3 ffmpeg-full icu libGL Nuget openssl SDL2 shared-mime-info ];
  
  patchPhase = ''
    for f in $(find . -iname "*.csproj"); do
      sed -i '/Include="Microsoft.SourceLink.GitHub"/d' $f
    done
  '';
  
  buildPhase = ''
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
    export HOME=$PWD/home 
    export LD_LIBRARY_PATH=${lib.strings.makeLibraryPath [ icu openssl SDL2 ]}

    # disable default-source so nuget does not try to download from online-repo
    nuget sources Disable -Name "nuget.org"
    # add all dependencies to a source called 'nixos'
    for package in ${toString deps}; do
      nuget add $package -Source nixos
    done 

    dotnet restore --source nixos osu.sln
    dotnet build osu.Desktop --runtime linux-x64 \
                             --configuration Release \
                             --no-restore \
                             --output build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r build/* $out/bin
  '';

  meta = {
    homepage = "https://osu.ppy.sh/home";
    description = "The bestest free-to-win rhythm game";
    license = with lib.licenses; [ cc-by-nc-40 mit ];
    maintainers = with lib.maintainers; [ skykanin ];
    # platforms = with lib.platforms; [ darwin linux ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
  
}
