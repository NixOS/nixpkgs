 buildGoModule fetchFromGitHub stdenv lib 

buildGoModule  
  pname  
  version  "7.3.1"


  src  fetchFromGitHub 
    owner  "concourse"
    repo  "concourse"
    rev  "v${version}"
    sha256  "sha256-JtzJDbln+n05oJjA/ydZWaH4dIPLL/ZsNg+Gr+YBcng="
  

  vendorSha256  "sha256-30rrRkPIH0sr8koKRLs1Twe6Z55+lr9gkgUDrY+WOTw="

  doCheck  true

  subPackages  [ ]

  buildFlagsArray  
    -ldflags
      -X github.com/concourse/concourse.Version=${version}
  

  postInstall  lib.optionalString (stdenv.hostPlatform  stdenv.buildPlatform)
    mkdir -p out/share/{bash-completion,zsh/site-functions}
    

     
  

