let
  mkAwsPackage = name: {
    goPackagePath = "github.com/aws/aws-sdk-go/${name}";
    fetch = {
      type = "git";
      url = "https://github.com/aws/aws-sdk-go";
      rev = "v1.14.13";
      sha256 = "0014b6kl3rbjhjbk7jz116wdgdls54b1bwz454pkn1snlvkj3qil";
    };
  };
in
[
  (mkAwsPackage "")
  (mkAwsPackage "aws/session")
  (mkAwsPackage "aws/sns")
  (mkAwsPackage "service/sns")
  {
    goPackagePath = "github.com/imdario/mergo";
    fetch = {
      type = "git";
      url = "https://github.com/imdario/mergo";
      rev = "v0.3.5";
      sha256 = "1mvgn89vp39gcpvhiq4n7nw5ipj7fk6h03jgc6fjwgvwvss213pb";
    };
  }
  {
    goPackagePath = "github.com/mitchellh/hashstructure";
    fetch = {
      type = "git";
      url = "https://github.com/mitchellh/hashstructure";
      rev = "2bca23e0e452137f789efbc8610126fd8b94f73b"; # has no releases as of writing
      sha256 = "0vpacsls26474wya360fjhzi6l4y8s8s251c4szvqxh17n5f5gk1";
    };
  }
]
